import authenticate from '../middleware/authenticate.js';
import database from '../models/index.js';
const db = database();
import express from 'express';

const router = express.Router();


router.get('/', authenticate, async (req, res) => {
    try {
        var terms = await db.Term.findAll({
            where: {
                student_id: req.userId
            },
            include: [
                {
                    model: db.User,
                    as: 'Student', // Changed to uppercase to match your model
                    attributes: ['id', 'first_name', 'last_name', 'email', 'program_id']
                },
                {
                    model: db.StudentCourse,
                    as: 'StudentCourses', // Changed to uppercase to match your model
                    include: [
                        {
                            model: db.Course,
                            as: 'Course', // Will need to be uppercase in StudentCourse model
                            attributes: ['id', 'name', 'code', 'competency_units', 'assessment_type', 'description']
                        },
                        {
                            model: db.User,
                            as: 'Instructor', // Will need to be uppercase in StudentCourse model
                            attributes: ['id', 'first_name', 'last_name', 'email', 'user_type'],
                            required: false // LEFT JOIN to include courses even without instructors
                        }
                    ]
                }
            ],
            order: [
                ['startDate', 'DESC'],
                [{ model: db.StudentCourse, as: 'StudentCourses' }, 'startDate', 'ASC']
            ]
        });
        
        res.status(200).json(terms);
        
    } catch (error) {
        console.error('Error fetching terms:', error);
        res.status(500).json({
            success: false,
            message: 'Error fetching terms',
            error: error.message
        });
    }
});

router.get('/:id', authenticate, async (req, res) => {
    try {
        var terms = await db.Term.findByPk(req.params.id, {
          
            include: [
                {
                    model: db.User,
                    as: 'Student', // Changed to uppercase to match your model
                    attributes: ['id', 'first_name', 'last_name', 'email', 'program_id']
                },
                {
                    model: db.StudentCourse,
                    as: 'StudentCourses', // Changed to uppercase to match your model
                    include: [
                        {
                            model: db.Course,
                            as: 'Course', // Will need to be uppercase in StudentCourse model
                            attributes: ['id', 'name', 'code', 'competency_units', 'assessment_type', 'description']
                        },
                        {
                            model: db.User,
                            as: 'Instructor', // Will need to be uppercase in StudentCourse model
                            attributes: ['id', 'first_name', 'last_name', 'email', 'user_type'],
                            required: false // LEFT JOIN to include courses even without instructors
                        }
                    ]
                }
            ],
            order: [
                ['startDate', 'DESC'],
                [{ model: db.StudentCourse, as: 'StudentCourses' }, 'startDate', 'ASC']
            ]
        });
        
        res.status(200).json(terms);
        
    } catch (error) {
        console.error('Error fetching terms:', error);
        res.status(500).json({
            success: false,
            message: 'Error fetching terms',
            error: error.message
        });
    }
});


export default router;