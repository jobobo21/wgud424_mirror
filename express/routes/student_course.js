// routes/student-courses.js
import authenticate from '../middleware/authenticate.js';
import database from '../models/index.js';
const db = database();
import express from 'express';

const router = express.Router();

/**
 * GET /student-courses
 * Retrieve all student courses for the authenticated user
 */
router.get('/', authenticate, async (req, res) => {
    try {
        const {
            status,
            include_instructor = 'true',
            include_course = 'true',
            include_term = 'true',
            active_only
        } = req.query;

        const where = {
            userId: req.userId
        };

        if (status) {
            where.status = status;
        }

        const include = [];

        if (include_course === 'true') {
            include.push({
                model: db.Course,
                as: 'Course',
                attributes: ['id', 'name', 'code', 'competency_units', 'assessment_type', 'description'],
                ...(active_only === 'true' && {
                    where: { is_active: true }
                })
            });
        }

        if (include_instructor === 'true') {
            include.push({
                model: db.User,
                as: 'Instructor',
                attributes: ['id', 'first_name', 'last_name', 'email', 'user_type'],
                required: false
            });
        }

        if (include_term === 'true') {
            include.push({
                model: db.Term,
                as: 'Term',
                attributes: ['id', 'term_no', 'startDate', 'endDate']
            });
        }

        const studentCourses = await db.StudentCourse.findAll({
            where,
            include,
            order: [['startDate', 'DESC']]
        });

        res.status(200).json(studentCourses);

    } catch (error) {
        console.error('Error fetching student courses:', error);
        res.status(500).json({
            success: false,
            message: 'Error fetching student courses',
            error: error.message
        });
    }
});

/**
 * GET /student-courses/:id
 * Retrieve a specific student course by ID
 */
router.get('/:id', authenticate, async (req, res) => {
    try {
        const { id } = req.params;

        const studentCourse = await db.StudentCourse.findOne({
            where: {
                id: parseInt(id),
                userId: req.userId
            },
            include: [
                {
                    model: db.Course,
                    as: 'Course',
                    attributes: ['id', 'name', 'code', 'competency_units', 'assessment_type', 'description'],
                    include: [{
                        model: db.Assessment,
                        as: "assessments",
                        attributes: ['id', 'name', 'type', 'passing_score', 'max_attempts', 'is_proctored', 'sequence_order'],
                        order: [['sequence_order', 'ASC']]
                    }]
                },
                {
                    model: db.User,
                    as: 'Instructor',
                    attributes: ['id', 'first_name', 'last_name', 'email', 'user_type'],
                    required: false
                },
                {
                    model: db.Term,
                    as: 'Term',
                    attributes: ['id', 'term_no', 'startDate', 'endDate']
                }
            ]
        });

        if (!studentCourse) {
            return res.status(404).json({
                success: false,
                message: 'Student course not found'
            });
        }

        // Fetch assessments separately to avoid association issues


        // Return the data directly with assessments added

        res.status(200).json(studentCourse);

    } catch (error) {
        console.error('Error fetching student course:', error);
        res.status(500).json({
            success: false,
            message: 'Error fetching student course',
            error: error.message
        });
    }
});

/**
 * GET /student-courses/course/:courseId
 * Get student course by course ID for the authenticated user
 */
router.get('/course/:courseId', authenticate, async (req, res) => {
    try {
        const { courseId } = req.params;

        const studentCourse = await db.StudentCourse.findOne({
            where: {
                courseId: parseInt(courseId),
                userId: req.userId
            },
            include: [
                {
                    model: db.Course,
                    as: 'Course',
                    attributes: ['id', 'name', 'code', 'competency_units', 'assessment_type', 'description']
                },
                {
                    model: db.User,
                    as: 'Instructor',
                    attributes: ['id', 'first_name', 'last_name', 'email'],
                    required: false
                },
                {
                    model: db.Term,
                    as: 'Term',
                    attributes: ['id', 'term_no', 'startDate', 'endDate']
                }
            ]
        });

        if (!studentCourse) {
            return res.status(404).json({
                success: false,
                message: 'Student course enrollment not found'
            });
        }

        res.status(200).json(studentCourse);

    } catch (error) {
        console.error('Error fetching student course by course ID:', error);
        res.status(500).json({
            success: false,
            message: 'Error fetching student course',
            error: error.message
        });
    }
});

/**
 * GET /student-courses/status/:status
 * Get all student courses by status for the authenticated user
 */
router.get('/status/:status', authenticate, async (req, res) => {
    try {
        const { status } = req.params;

        const validStatuses = ['c', 'a', 'i', 'w'];
        if (!validStatuses.includes(status)) {
            return res.status(400).json({
                success: false,
                message: 'Invalid status. Valid statuses are: c, a, i, w'
            });
        }

        const studentCourses = await db.StudentCourse.findAll({
            where: {
                userId: req.userId,
                status: status
            },
            include: [
                {
                    model: db.Course,
                    as: 'Course',
                    attributes: ['id', 'name', 'code', 'competency_units', 'assessment_type']
                },
                {
                    model: db.User,
                    as: 'Instructor',
                    attributes: ['id', 'first_name', 'last_name', 'email'],
                    required: false
                },
                {
                    model: db.Term,
                    as: 'Term',
                    attributes: ['id', 'term_no', 'startDate', 'endDate']
                }
            ],
            order: [['startDate', 'DESC']]
        });

        res.status(200).json(studentCourses);

    } catch (error) {
        console.error('Error fetching student courses by status:', error);
        res.status(500).json({
            success: false,
            message: 'Error fetching student courses',
            error: error.message
        });
    }
});

/**
 * GET /student-courses/term/:termId
 * Get all student courses for a specific term
 */
router.get('/term/:termId', authenticate, async (req, res) => {
    try {
        const { termId } = req.params;

        const studentCourses = await db.StudentCourse.findAll({
            where: {
                userId: req.userId,
                term_id: parseInt(termId)
            },
            include: [
                {
                    model: db.Course,
                    as: 'Course',
                    attributes: ['id', 'name', 'code', 'competency_units', 'assessment_type', 'description']
                },
                {
                    model: db.User,
                    as: 'Instructor',
                    attributes: ['id', 'first_name', 'last_name', 'email'],
                    required: false
                },
                {
                    model: db.Term,
                    as: 'Term',
                    attributes: ['id', 'term_no', 'startDate', 'endDate']
                }
            ],
            order: [['startDate', 'ASC']]
        });

        res.status(200).json(studentCourses);

    } catch (error) {
        console.error('Error fetching student courses by term:', error);
        res.status(500).json({
            success: false,
            message: 'Error fetching student courses for term',
            error: error.message
        });
    }
});

export default router;