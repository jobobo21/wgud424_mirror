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

    var queryStr = `Select (SELECT SUM(competency_units) FROM courses WHERE id IN (SELECT courseId FROM user_course WHERE status = 'c' and userId = ${req.userId})) as complete_cu, `+
`(SELECT SUM(competency_units) FROM courses WHERE id IN (SELECT courseId FROM user_course WHERE status ='a' and userId = ${req.userId})) as active_cu, `+
`(SELECT SUM(competency_units) FROM courses WHERE id in (SELECT course_id FROM program_courses WHERE program_id = ${user.program_id})) as total_cu;`

    const [results, metadata] = await db.sequelize.query(queryStr);
    var result = results[0];
    Object.keys(result).forEach(key => result[key] = parseFloat(result[key]))
    result.pct_complete = ((result.complete_cu / result.total_cu) * 100).toFixed(0);
    result.pct_complete = parseFloat(result.pct_complete);
    result.remaining_cu = result.total_cu - result.complete_cu
    result.user_first_name = user.first_name;
    result.user_last_name = user.last_name;
    res.status(200).json(result);


})

export default router;