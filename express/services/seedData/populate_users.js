import database from "../../models/index.js";
import bcrypt from "bcrypt";
import fs from "fs";

// Read users from JSON file
const usersData = JSON.parse(fs.readFileSync('./users.json', 'utf8'));

// Password variations by user type
const passwords = {
    s: ['WguStudent2025!', 'Student123!', 'Learning2026!', 'Education123!', 'Future2026!', 'StudyHard!', 'WguLearner!', 'Knowledge2026!', 'Progress2026!', 'Graduate2025!', 'Success2026!', 'Achievement!', 'Study2026!', 'Degree2026!', 'Student2025!', 'Excellence!', 'CompetencyBased!', 'NightOwl2025!', 'OnlineEd!', 'WguSuccess!', 'Technology!'],
    m: ['Mentor2025!', 'Guide123!', 'Advisor!', 'Support2025!', 'Mentor123!', 'Guidance!', 'MentorSupport!'],
    i: ['Instructor2025!', 'Teach2025!', 'Faculty123!', 'Educator!', 'Instruction!', 'Teaching2025!', 'Professor2025!']
};

// Function to get random password by type
function getPasswordByType(type) {
    const typePasswords = passwords[type.toLowerCase()];
    return typePasswords[Math.floor(Math.random() * typePasswords.length)];
}

// Transform users to match your database structure
const users = usersData.map(user => ({
    first_name: user.first_name,
    last_name: user.last_name,
    email: user.email,
    password: getPasswordByType(user.type),
    type: user.type.toLowerCase(),
    grad_date: user.grad_date ? new Date(user.grad_date) : null
}));

const db = database();

async function Populate() {
    var promises = users.map(async (u) => {
        var hp = await bcrypt.hash(u.password, 10);
        return { ...u, password: hp }
    });
    var newusers = await Promise.all(promises);
    await db.User.bulkCreate(newusers);
    console.log(`Successfully created ${newusers.length} users`);
    
    // Save the users with plain text passwords for reference
    const referenceData = users.map(user => ({
        ...user,
        grad_date: user.grad_date ? user.grad_date.toISOString().split('T')[0] : null,
        created_at: new Date().toISOString()
    }));
    
    fs.writeFileSync('./users_with_passwords_reference.json', JSON.stringify(referenceData, null, 2));
    console.log('Reference file saved as users_with_passwords_reference.json');
}

Populate()
    .then(() => {
        console.log('User population completed');
        process.exit();
    })
    .catch(err => {
        console.error('Error populating users:', err);
        process.exit(1);
    });