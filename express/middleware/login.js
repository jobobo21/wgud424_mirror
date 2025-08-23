// routes/auth.js
import express from 'express';
const router = express.Router();
//  const User = require('../models/User');
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import bodyParser from 'body-parser';
import database from '../models/index.js'
const db = database();
var jsonParser = bodyParser.json()
// User login
router.post('/', jsonParser, async (req, res) => {

    console.log(req.body);
    try {
        const { email, password } = req.body;
        const user = await db.User.findOne({ email });
        if (!user) {
            return res.status(401).json({ error: 'Authentication failed' });
        }
        const passwordMatch = await bcrypt.compare(password, user.password);
        if (!passwordMatch) {
            return res.status(401).json({ error: 'Authentication failed' });
        }
        const token = jwt.sign({ userId: user.id }, 'your-secret-key', {
            expiresIn: '1h',
        });
        res.status(200).json({ token });
    } catch (error) {
        console.log(error);
        res.status(500).json({ error: 'Login failed' });
    }
});
export default router;