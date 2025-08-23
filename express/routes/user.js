import database from '../models/index.js';
const db = database();
import express from 'express';

const router = express.Router();


router.get('/', async (req, res) => {

    var courses = await db.User.findAll({});
    res.json(courses);
 });
 export default router;