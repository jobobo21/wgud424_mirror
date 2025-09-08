import authenticate from '../middleware/authenticate.js';
import database from '../models/index.js';
const db = database();
import express from 'express';

const router = express.Router();


router.get('/', async (req, res) => {

    var courses = await db.User.findAll({});
    res.json(courses);
});
router.get('/student_status', authenticate, async (req, res) => {
    var user = await db.User.findByPk(req.userId);

    var queryStr = `Select (SELECT SUM(competency_units) FROM courses WHERE id IN (SELECT courseId FROM student_course WHERE status = 'c' and userId = ${req.userId})) as complete_cu, ` +
        `(SELECT SUM(competency_units) FROM courses WHERE id IN (SELECT courseId FROM student_course WHERE status ='a' and userId = ${req.userId})) as active_cu, ` +
        `(SELECT SUM(competency_units) FROM courses WHERE id in (SELECT course_id FROM program_courses WHERE program_id = ${user.program_id})) as total_cu;`

    const [results, metadata] = await db.sequelize.query(queryStr);
    var result = results[0];
    Object.keys(result).forEach(key => result[key] = parseFloat(result[key]))
    result.pct_complete = ((result.complete_cu / result.total_cu) * 100).toFixed(0);
    result.pct_complete = parseFloat(result.pct_complete);
    result.remaining_cu = result.total_cu - result.complete_cu
    result.user_first_name = user.first_name;
    result.user_last_name = user.last_name;

    if (user.mentor_id) {
        var mentor = await db.User.findByPk(user.mentor_id);
        mentor = mentor.toJSON()
        delete mentor.password;
        result.mentor = mentor
    }

    res.status(200).json(result);


})
router.get("/instructor", async (req, res) => {
        const instructor = await db.User.findOne({ where:{
            user_type: "i"
        }, order: db.sequelize.random() })
        res.json(instructor);
})
router.get("/students", authenticate, async (req, res) => {
    var students = await db.User.findAll({
        where: {
            user_type: "s"
        },
        attributes: ['first_name', 'last_name', 'email'],
        include: [
            {
                model: db.Program,
                as: 'program',
                attributes: ['name', 'code', 'degree_level']
            }
        ]
    });
    var results = students.map( s => {
        s = s.toJSON()
        s.full_name = s.first_name + " " + s.last_name;
        return s
    })
    if (req.query && req.query.searchString) {
        results = results.filter(s => {
            if (JSON.stringify(s).toLowerCase().includes(req.query.searchString.toLowerCase())) {
                return s
            }
        })
        res.status(200).json(results)
    } else {
        res.status(200).json(results)
    }
})


export default router;