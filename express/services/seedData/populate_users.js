import database from "../../models/index.js";
import bcrypt from "bcrypt";
const users = [
    {
        first_name: "Johan",
        last_name: "Teller",
        email: "jtell73@wgu.edu",
        password: "wgu1231231",
        type: "s",
        grad_date: new Date(2025, 10, 1)
    }

]

const db = database();

async function Populate() {
    var promisses = users.map(async (u) => {
        var hp = await bcrypt.hash(u.password, 10);
        return { ...u, password: hp }
    })
    var newusers = await Promise.all(promisses);
    db.User.bulkCreate(newusers);


}
Populate()
process.exit();