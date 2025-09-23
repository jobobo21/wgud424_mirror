import express from "express";
import { Sequelize } from 'sequelize';
import login from './middleware/login.js';
import dotenv from 'dotenv';
import course from "./routes/course.js";
import user from "./routes/user.js";
import term from "./routes/term.js";
import student_course from "./routes/student_course.js";
import student_assessment from "./routes/student_assessments.js";
dotenv.config();
const app = express();
app.use(express.json());
const port = process.env.PORT || 5000;
// Example for MYSQL

app.get("/", (req, res) => {
  return res.status(200).send({
    message: "WGU D424 Software API",
    title: process.env.Title,
    
  });
});
app.use("/login", login);

app.use("/course", course);
app.use("/user", user);
app.use("/terms", term);
app.use("/student_course", student_course)
app.use("/student_assessment", student_assessment)
app.listen(port, () => {
  console.log("Listening on " + port);
});

export default app;