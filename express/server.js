import express from "express";
import { Sequelize } from 'sequelize';
import login from './middleware/login.js';
import dotenv from 'dotenv';

dotenv.config();
const app = express();

const port = process.env.PORT || 5000;
const sequelize = new Sequelize(process.env.DATABASE_URL, {
  dialect: 'mysql',
  dialectOptions: {
    ssl: {
      require: true,
      rejectUnauthorized: false
    }
  }
}) // Example for MYSQL
var status = "Not Connected"
try {
  await sequelize.authenticate();
  console.log('Connection has been established successfully.');
  status = "Connected To Database"
} catch (error) {
  console.error('Unable to connect to the database:', error);
  console.log("Database String", process.env.DATABASE_URL);
}
app.get("/", (req, res) => {
  return res.status(200).send({
    message: "Hello World!",
    title: process.env.Title,
    status
  });
});
app.use("/login", login);

app.listen(port, () => {
  console.log("Listening on " + port);
});

export default app;