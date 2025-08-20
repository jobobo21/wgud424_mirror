import express  from "express";
import { Sequelize } from 'sequelize';
const app = express();

const port = process.env.PORT || 5000;
const sequelize = new Sequelize('mysql://'+process.env.DATABASE_URL) // Example for MYSQL
var status = "Not Connected"
try {
  await sequelize.authenticate();
  console.log('Connection has been established successfully.');
  status = "Connected To Database"
} catch (error) {
  console.error('Unable to connect to the database:', error);
}
app.get("/", (req, res) => {
  return res.status(200).send({
    message: "Hello World!",
    title: process.env.Title,
    status
  });
});

app.listen(port, () => {
  console.log("Listening on " + port);
});

module.exports = app;