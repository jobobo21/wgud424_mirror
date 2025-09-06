// routes/student-assessments.js
import authenticate from '../middleware/authenticate.js';
import database from '../models/index.js';
const db = database();
import express from 'express';

const router = express.Router();

/**
 * GET /student-assessments
 * Retrieve all student assessments for the authenticated user
 */
router.get('/', authenticate, async (req, res) => {
    try {
        const {
            status,
            assessment_type,
            include_course = 'true',
            include_student_course = 'true',
            completed_only,
            in_progress_only
        } = req.query;

        // Build where clause for student_assessment
        let where = {};
        
        // Filter by completion status
        if (completed_only === 'true') {
            where.endDate = { [db.Sequelize.Op.not]: null };
        } else if (in_progress_only === 'true') {
            where.endDate = null;
        }

        const include = [];

        // Always include student course to filter by user
        const studentCourseInclude = {
            model: db.StudentCourse,
            as: 'StudentCourse',
            where: { userId: req.userId },
            attributes: ['id', 'userId', 'courseId', 'startDate', 'endDate', 'status', 'term_id'],
            required: true
        };

        // Add course and instructor info if requested
        if (include_course === 'true') {
            studentCourseInclude.include = [
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
                    attributes: ['id', 'term_no', 'startDate', 'endDate'],
                    required: false
                }
            ];
        }

        include.push(studentCourseInclude);

        // Include assessment details
        const assessmentInclude = {
            model: db.Assessment,
            as: 'Assessment',
            attributes: ['id', 'name', 'type', 'description', 'passing_score', 'max_attempts', 'time_limit_minutes', 'is_proctored', 'sequence_order']
        };

        // Filter by assessment type if specified
        if (assessment_type && ['O', 'P'].includes(assessment_type)) {
            assessmentInclude.where = { type: assessment_type };
        }

        include.push(assessmentInclude);

        const studentAssessments = await db.StudentAssessment.findAll({
            where,
            include,
            order: [['startDate', 'DESC']]
        });

        res.status(200).json(studentAssessments);

    } catch (error) {
        console.error('Error fetching student assessments:', error);
        res.status(500).json({
            success: false,
            message: 'Error fetching student assessments',
            error: error.message
        });
    }
});

/**
 * GET /student-assessments/:id
 * Retrieve a specific student assessment by ID
 */
router.get('/:id', authenticate, async (req, res) => {
    try {
        const { id } = req.params;

        const studentAssessment = await db.StudentAssessment.findOne({
            where: {
                student_assessmentId: parseInt(id)
            },
            include: [
                {
                    model: db.StudentCourse,
                    as: 'StudentCourse',
                    where: { userId: req.userId },
                    attributes: ['id', 'userId', 'courseId', 'startDate', 'endDate', 'status', 'term_id'],
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
                            attributes: ['id', 'term_no', 'startDate', 'endDate'],
                            required: false
                        }
                    ]
                },
                {
                    model: db.Assessment,
                    as: 'Assessment',
                    attributes: ['id', 'name', 'type', 'description', 'passing_score', 'max_attempts', 'time_limit_minutes', 'is_proctored', 'sequence_order']
                }
            ]
        });

        if (!studentAssessment) {
            return res.status(404).json({
                success: false,
                message: 'Student assessment not found'
            });
        }

        res.status(200).json(studentAssessment);

    } catch (error) {
        console.error('Error fetching student assessment:', error);
        res.status(500).json({
            success: false,
            message: 'Error fetching student assessment',
            error: error.message
        });
    }
});

/**
 * GET /student-assessments/course/:courseId
 * Get all assessments for a specific course for the authenticated user
 */
router.get('/course/:courseId', authenticate, async (req, res) => {
    try {
        const { courseId } = req.params;

        const studentAssessments = await db.StudentAssessment.findAll({
            include: [
                {
                    model: db.StudentCourse,
                    as: 'StudentCourse',
                    where: { 
                        userId: req.userId,
                        courseId: parseInt(courseId)
                    },
                    attributes: ['id', 'userId', 'courseId', 'startDate', 'endDate', 'status'],
                    include: [
                        {
                            model: db.Course,
                            as: 'Course',
                            attributes: ['id', 'name', 'code', 'competency_units', 'assessment_type']
                        }
                    ]
                },
                {
                    model: db.Assessment,
                    as: 'Assessment',
                    attributes: ['id', 'name', 'type', 'description', 'passing_score', 'max_attempts', 'is_proctored', 'sequence_order']
                }
            ],
            order: [[{model: db.Assessment, as: 'Assessment'}, 'sequence_order', 'ASC']]
        });

        if (!studentAssessments.length) {
            return res.status(404).json({
                success: false,
                message: 'No assessments found for this course'
            });
        }

        res.status(200).json(studentAssessments);

    } catch (error) {
        console.error('Error fetching course assessments:', error);
        res.status(500).json({
            success: false,
            message: 'Error fetching course assessments',
            error: error.message
        });
    }
});

/**
 * GET /student-assessments/status/completed
 * Get all completed assessments for the authenticated user
 */
router.get('/status/completed', authenticate, async (req, res) => {
    try {
        const studentAssessments = await db.StudentAssessment.findAll({
            where: {
                endDate: { [db.Sequelize.Op.not]: null }
            },
            include: [
                {
                    model: db.StudentCourse,
                    as: 'StudentCourse',
                    where: { userId: req.userId },
                    attributes: ['id', 'userId', 'courseId', 'status'],
                    include: [
                        {
                            model: db.Course,
                            as: 'Course',
                            attributes: ['id', 'name', 'code', 'competency_units']
                        }
                    ]
                },
                {
                    model: db.Assessment,
                    as: 'Assessment',
                    attributes: ['id', 'name', 'type', 'passing_score', 'sequence_order']
                }
            ],
            order: [['endDate', 'DESC']]
        });

        res.status(200).json(studentAssessments);

    } catch (error) {
        console.error('Error fetching completed assessments:', error);
        res.status(500).json({
            success: false,
            message: 'Error fetching completed assessments',
            error: error.message
        });
    }
});

/**
 * GET /student-assessments/status/in-progress
 * Get all in-progress assessments for the authenticated user
 */
router.get('/status/in-progress', authenticate, async (req, res) => {
    try {
        const studentAssessments = await db.StudentAssessment.findAll({
            where: {
                endDate: null,
                startDate: { [db.Sequelize.Op.not]: null }
            },
            include: [
                {
                    model: db.StudentCourse,
                    as: 'StudentCourse',
                    where: { userId: req.userId },
                    attributes: ['id', 'userId', 'courseId', 'status'],
                    include: [
                        {
                            model: db.Course,
                            as: 'Course',
                            attributes: ['id', 'name', 'code', 'competency_units']
                        },
                        {
                            model: db.User,
                            as: 'Instructor',
                            attributes: ['id', 'first_name', 'last_name', 'email'],
                            required: false
                        }
                    ]
                },
                {
                    model: db.Assessment,
                    as: 'Assessment',
                    attributes: ['id', 'name', 'type', 'description', 'passing_score', 'max_attempts', 'time_limit_minutes', 'is_proctored', 'sequence_order']
                }
            ],
            order: [['startDate', 'ASC']]
        });

        res.status(200).json(studentAssessments);

    } catch (error) {
        console.error('Error fetching in-progress assessments:', error);
        res.status(500).json({
            success: false,
            message: 'Error fetching in-progress assessments',
            error: error.message
        });
    }
});

/**
 * GET /student-assessments/type/:type
 * Get all assessments by type (O for Objective, P for Performance)
 */
router.get('/type/:type', authenticate, async (req, res) => {
    try {
        const { type } = req.params;

        if (!['O', 'P'].includes(type)) {
            return res.status(400).json({
                success: false,
                message: 'Invalid assessment type. Valid types are: O (Objective), P (Performance)'
            });
        }

        const studentAssessments = await db.StudentAssessment.findAll({
            include: [
                {
                    model: db.StudentCourse,
                    as: 'StudentCourse',
                    where: { userId: req.userId },
                    attributes: ['id', 'userId', 'courseId', 'status'],
                    include: [
                        {
                            model: db.Course,
                            as: 'Course',
                            attributes: ['id', 'name', 'code', 'competency_units']
                        }
                    ]
                },
                {
                    model: db.Assessment,
                    as: 'Assessment',
                    where: { type: type },
                    attributes: ['id', 'name', 'type', 'description', 'passing_score', 'max_attempts', 'time_limit_minutes', 'is_proctored', 'sequence_order']
                }
            ],
            order: [['startDate', 'DESC']]
        });

        res.status(200).json(studentAssessments);

    } catch (error) {
        console.error('Error fetching assessments by type:', error);
        res.status(500).json({
            success: false,
            message: 'Error fetching assessments by type',
            error: error.message
        });
    }
});

/**
 * GET /student-assessments/term/:termId
 * Get all assessments for a specific term
 */
router.get('/term/:termId', authenticate, async (req, res) => {
    try {
        const { termId } = req.params;

        const studentAssessments = await db.StudentAssessment.findAll({
            include: [
                {
                    model: db.StudentCourse,
                    as: 'StudentCourse',
                    where: { 
                        userId: req.userId,
                        term_id: parseInt(termId)
                    },
                    attributes: ['id', 'userId', 'courseId', 'status', 'term_id'],
                    include: [
                        {
                            model: db.Course,
                            as: 'Course',
                            attributes: ['id', 'name', 'code', 'competency_units']
                        },
                        {
                            model: db.Term,
                            as: 'Term',
                            attributes: ['id', 'term_no', 'startDate', 'endDate']
                        }
                    ]
                },
                {
                    model: db.Assessment,
                    as: 'Assessment',
                    attributes: ['id', 'name', 'type', 'description', 'passing_score', 'sequence_order']
                }
            ],
            order: [[{model: db.Assessment, as: 'Assessment'}, 'sequence_order', 'ASC']]
        });

        res.status(200).json(studentAssessments);

    } catch (error) {
        console.error('Error fetching assessments by term:', error);
        res.status(500).json({
            success: false,
            message: 'Error fetching assessments for term',
            error: error.message
        });
    }
});

/**
 * PUT /student-assessments/:id/complete
 * Mark an assessment as completed (set endDate)
 */
router.put('/:id/complete', authenticate, async (req, res) => {
    try {
        const { id } = req.params;
        const { endDate = new Date() } = req.body;

        // Verify the assessment belongs to the authenticated user
        const studentAssessment = await db.StudentAssessment.findOne({
            where: {
                student_assessmentId: parseInt(id)
            },
            include: [
                {
                    model: db.StudentCourse,
                    as: 'StudentCourse',
                    where: { userId: req.userId },
                    attributes: ['id', 'userId']
                }
            ]
        });

        if (!studentAssessment) {
            return res.status(404).json({
                success: false,
                message: 'Student assessment not found'
            });
        }

        if (studentAssessment.endDate) {
            return res.status(400).json({
                success: false,
                message: 'Assessment is already completed'
            });
        }

        await studentAssessment.update({
            endDate: new Date(endDate)
        });

        res.status(200).json({
            success: true,
            message: 'Assessment marked as completed',
            data: studentAssessment
        });

    } catch (error) {
        console.error('Error completing assessment:', error);
        res.status(500).json({
            success: false,
            message: 'Error completing assessment',
            error: error.message
        });
    }
});

export default router;