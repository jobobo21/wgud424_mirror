// middleware/authMiddleware.js

import jwt from 'jsonwebtoken';

function authenticate(req, res, next) {
const token = req.header('Authorization');
console.log(token);
if (!token) return res.status(401).json({ error: 'Access denied' });
try {
 const decoded = jwt.verify(token, 'your-secret-key');
 console.log(decoded.userId);
 req.userId = decoded.userId;
 next();
 } catch (error) {
 res.status(401).json({ error: 'Invalid token' });
 }
 };

export default authenticate;