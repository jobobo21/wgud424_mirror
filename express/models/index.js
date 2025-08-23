// Initialize all models function
import { College, Assessment, AssessmentType, Program, ProgramCourse, Prerequisite, Course, CompetencyCategory } from "./catalog.js";
import { Sequelize } from "sequelize";
import User from "./user.js";
import dotenv from 'dotenv';
dotenv.config();

function DB() {
    var models = {};
    const sequelize = new Sequelize(process.env.DATABASE_URL, {
        dialect: 'mysql',
        dialectOptions: {
            ssl: {
                require: true,
                rejectUnauthorized: false
            }
        }
    })

    // Initialize all models
    models.College = College(sequelize);
    models.AssessmentType = AssessmentType(sequelize);
    models.CompetencyCategory = CompetencyCategory(sequelize);
    models.Program = Program(sequelize);
    models.Course = Course(sequelize);
    models.ProgramCourse = ProgramCourse(sequelize);
    models.Prerequisite = Prerequisite(sequelize);
    models.Assessment = Assessment(sequelize);
    models.User = User(sequelize);

    // Set up associations
    Object.values(models).forEach(model => {
        if (model.associate) {
            model.associate(models);
        }
    });

    return models;
};
function test() {
    return {Test: "Test"}; 
}
export default DB;