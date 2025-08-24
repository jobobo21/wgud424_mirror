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
    var userId = req.user.userId;
    var user = await db.User.findByPk(userId);

    var queryStr = `SELECT SUM(competency_units) into @complete_cu FROM courses WHERE id IN (SELECT courseId FROM user_course WHERE status = 'c' and userId = ${userId});
SELECT SUM(competency_units) into @active_cu FROM courses WHERE id IN (SELECT courseId FROM user_course WHERE status ='a' and userId = ${userId});
SELECT SUM(competency_units) into @total_cu FROM courses WHERE id in (SELECT course_id FROM program_courses WHERE program_id = ${user.program_id});

Select @complete_cu as complete_cu, @active_cu as active_cu, @total_cu as total_cu, Round(((@complete_cu/@total_cu) * 100), 2) as pct_complete, Round(@total_cu - @complete_cu) as remaining;`;

    const [results, metadata] = await db.sequelize.query(queryStr);
    res.json(results[0]);

})

export default router;