// routes/student-courses.js
import { Op, Sequelize } from 'sequelize';
import authenticate from '../middleware/authenticate.js';
import database from '../models/index.js';
const db = database();
import express from 'express';

const router = express.Router();

// Custom error class for better error handling
class StudentCourseError extends Error {
    constructor(message, statusCode = 500, details = null) {
        super(message);
        this.statusCode = statusCode;
        this.details = details;
        this.name = 'StudentCourseError';
    }
}

// Validation helper functions
const validateStatus = (status) => {
    const validStatuses = ['c', 'a', 'i', 'w'];
    if (!validStatuses.includes(status)) {
        throw new StudentCourseError(
            `Invalid status. Valid statuses are: ${validStatuses.join(', ')}`,
            400
        );
    }
    return true;
};

const validateId = (id, fieldName = 'id') => {
    const parsedId = parseInt(id);
    if (isNaN(parsedId) || parsedId <= 0) {
        throw new StudentCourseError(
            `Invalid ${fieldName}: must be a positive integer`,
            400
        );
    }
    return parsedId;
};

const validateQueryParams = (query) => {
    const validParams = ['status', 'include_instructor', 'include_course', 'include_term', 'active_only'];
    const invalidParams = Object.keys(query).filter(key => !validParams.includes(key));
    
    if (invalidParams.length > 0) {
        console.warn(`Unknown query parameters received: ${invalidParams.join(', ')}`);
    }
    
    return {
        status: query.status,
        include_instructor: query.include_instructor === 'true',
        include_course: query.include_course === 'true',
        include_term: query.include_term === 'true',
        active_only: query.active_only === 'true'
    };
};

// Transaction wrapper for database operations
const withTransaction = async (callback) => {
    const transaction = await db.sequelize.transaction();
    try {
        const result = await callback(transaction);
        await transaction.commit();
        return result;
    } catch (error) {
        await transaction.rollback();
        throw error;
    }
};

/**
 * GET /student-courses
 * Retrieve all student courses for the authenticated user
 */
router.get('/', authenticate, async (req, res) => {
    try {
        const params = validateQueryParams(req.query);
        
        if (params.status) {
            validateStatus(params.status);
        }

        const where = {
            userId: req.userId
        };

        if (params.status) {
            where.status = params.status;
        }

        const include = [];

        if (params.include_course) {
            include.push({
                model: db.Course,
                as: 'Course',
                attributes: ['id', 'name', 'code', 'competency_units', 'assessment_type', 'description'],
                ...(params.active_only && {
                    where: { is_active: true }
                })
            });
        }

        if (params.include_instructor) {
            include.push({
                model: db.User,
                as: 'Instructor',
                attributes: ['id', 'first_name', 'last_name', 'email', 'user_type'],
                required: false
            });
        }

        if (params.include_term) {
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
        
        if (error instanceof StudentCourseError) {
            return res.status(error.statusCode).json({
                success: false,
                message: error.message,
                details: error.details
            });
        }
        
        res.status(500).json({
            success: false,
            message: 'Error fetching student courses',
            error: process.env.NODE_ENV === 'development' ? error.message : 'Internal server error'
        });
    }
});

/**
 * GET /student-courses/upcomming
 * Get upcoming courses eligible for enrollment
 */
router.get('/upcomming', authenticate, async (req, res) => {
    try {
        // Get user info with error handling
        const user = await db.User.findByPk(req.userId, {
            attributes: ["first_name", "last_name", "email", "program_id"],
        });
        
        if (!user) {
            throw new StudentCourseError('User not found', 404);
        }
        
        if (!user.program_id) {
            throw new StudentCourseError('User is not enrolled in a program', 400);
        }
        
        const userData = user.toJSON();
        
        // Get all student courses that are not eligible to add
        const studentCourses = await db.StudentCourse.findAll({
            where: {
                userId: req.userId,
                status: { [Op.in]: ["c", "a"] }
            },
            attributes: ["courseId"]
        });
        
        const enrolledCourseIds = studentCourses.map(sc => sc.courseId).filter(id => id != null);

        // Query all courses in program
        const whereClause = {
            program_id: userData.program_id
        };
        
        if (enrolledCourseIds.length > 0) {
            whereClause.course_id = {
                [Op.notIn]: enrolledCourseIds
            };
        }
        
        const programCourses = await db.ProgramCourse.findAll({
            where: whereClause,
            include: [{
                model: db.Course,
                as: "course",
                required: true // Ensure course exists
            }]
        });

        const courses = programCourses.map(pc => {
            const pcData = pc.toJSON();
            if (!pcData.course) {
                console.warn(`ProgramCourse ${pc.id} has no associated course`);
                return null;
            }
            return { ...pcData.course, program_id: pcData.program_id };
        }).filter(course => course !== null);

        res.status(200).json(courses);

    } catch (error) {
        console.error('Error fetching upcoming courses:', error);
        
        if (error instanceof StudentCourseError) {
            return res.status(error.statusCode).json({
                success: false,
                message: error.message,
                details: error.details
            });
        }
        
        res.status(500).json({
            success: false,
            message: 'Error fetching upcoming courses',
            error: process.env.NODE_ENV === 'development' ? error.message : 'Internal server error'
        });
    }
});

/**
 * GET /student-courses/:id
 * Retrieve a specific student course by ID
 */
router.get('/:id', authenticate, async (req, res) => {
    try {
        const id = validateId(req.params.id, 'student course ID');

        const studentCourse = await db.StudentCourse.findOne({
            where: {
                id,
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
                    attributes: ['id', 'first_name', 'last_name', 'email', 'user_type'],
                    required: false
                },
                {
                    model: db.Term,
                    as: 'Term',
                    attributes: ['id', 'term_no', 'startDate', 'endDate']
                },
                {
                    model: db.StudentAssessment,
                    as: "StudentAssessments",
                    include: {
                        model: db.Assessment,
                        as: "Assessment",
                        attributes: ['id', 'name', 'type', 'description', 'max_attempts', 
                                   'is_proctored', 'sequence_order', 'passing_score', 'time_limit_minutes']
                    }
                }
            ]
        });

        if (!studentCourse) {
            throw new StudentCourseError('Student course not found', 404);
        }

        res.status(200).json(studentCourse);

    } catch (error) {
        console.error('Error fetching student course:', error);
        
        if (error instanceof StudentCourseError) {
            return res.status(error.statusCode).json({
                success: false,
                message: error.message,
                details: error.details
            });
        }
        
        res.status(500).json({
            success: false,
            message: 'Error fetching student course',
            error: process.env.NODE_ENV === 'development' ? error.message : 'Internal server error'
        });
    }
});

/**
 * GET /student-courses/course/:courseId
 * Get student course by course ID for the authenticated user
 */
router.get('/course/:courseId', authenticate, async (req, res) => {
    try {
        const courseId = validateId(req.params.courseId, 'course ID');

        const studentCourse = await db.StudentCourse.findOne({
            where: {
                courseId,
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
            throw new StudentCourseError('Student course enrollment not found', 404);
        }

        res.status(200).json(studentCourse);

    } catch (error) {
        console.error('Error fetching student course by course ID:', error);
        
        if (error instanceof StudentCourseError) {
            return res.status(error.statusCode).json({
                success: false,
                message: error.message,
                details: error.details
            });
        }
        
        res.status(500).json({
            success: false,
            message: 'Error fetching student course',
            error: process.env.NODE_ENV === 'development' ? error.message : 'Internal server error'
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
        validateStatus(status);

        const studentCourses = await db.StudentCourse.findAll({
            where: {
                userId: req.userId,
                status
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
        
        if (error instanceof StudentCourseError) {
            return res.status(error.statusCode).json({
                success: false,
                message: error.message,
                details: error.details
            });
        }
        
        res.status(500).json({
            success: false,
            message: 'Error fetching student courses',
            error: process.env.NODE_ENV === 'development' ? error.message : 'Internal server error'
        });
    }
});

/**
 * GET /student-courses/term/:termId
 * Get all student courses for a specific term
 */
router.get('/term/:termId', authenticate, async (req, res) => {
    try {
        const termId = validateId(req.params.termId, 'term ID');

        const studentCourses = await db.StudentCourse.findAll({
            where: {
                userId: req.userId,
                term_id: termId
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
        
        if (error instanceof StudentCourseError) {
            return res.status(error.statusCode).json({
                success: false,
                message: error.message,
                details: error.details
            });
        }
        
        res.status(500).json({
            success: false,
            message: 'Error fetching student courses for term',
            error: process.env.NODE_ENV === 'development' ? error.message : 'Internal server error'
        });
    }
});

/**
 * DELETE /student-courses/:id
 * Delete a student course enrollment
 */
router.delete("/:id", authenticate, async (req, res) => {
    try {
        const id = validateId(req.params.id, 'student course ID');
        
        // First check if the course exists and belongs to the user
        const studentCourse = await db.StudentCourse.findOne({
            where: {
                id,
                userId: req.userId
            }
        });
        
        if (!studentCourse) {
            throw new StudentCourseError('Student course not found or access denied', 404);
        }
        
        // Check if course can be deleted based on status
        if (studentCourse.status === 'c') {
            throw new StudentCourseError('Cannot delete completed courses', 400);
        }
        
        const deletedCount = await withTransaction(async (transaction) => {
            // Delete associated student assessments first
            await db.StudentAssessment.destroy({
                where: { student_courseId: id },
                transaction
            });
            
            // Delete the student course
            return await db.StudentCourse.destroy({
                where: { id },
                transaction
            });
        });
        
        res.status(200).json({
            success: true,
            message: 'Student course deleted successfully',
            deletedCount
        });
        
    } catch (error) {
        console.error('Error deleting student course:', error);
        
        if (error instanceof StudentCourseError) {
            return res.status(error.statusCode).json({
                success: false,
                message: error.message,
                details: error.details
            });
        }
        
        res.status(500).json({
            success: false,
            message: 'Error deleting student course',
            error: process.env.NODE_ENV === 'development' ? error.message : 'Internal server error'
        });
    }
});

/**
 * POST /student-courses
 * Create a new student course enrollment
 */
router.post("/", authenticate, async (req, res) => {
    try {
        // Validate required fields
        if (!req.body.courseId) {
            throw new StudentCourseError('Course ID is required', 400);
        }
        
        const courseId = validateId(req.body.courseId, 'course ID');
        
        // Check if course exists
        const course = await db.Course.findByPk(courseId);
        if (!course) {
            throw new StudentCourseError('Course not found', 404);
        }
        
        // Check if student is already enrolled in this course
        const existingEnrollment = await db.StudentCourse.findOne({
            where: {
                userId: req.userId,
                courseId,
                status: { [Op.in]: ['a', 'i'] } // Active or In-progress
            }
        });
        
        if (existingEnrollment) {
            throw new StudentCourseError('Already enrolled in this course', 409);
        }
        
        // Find a random instructor
        const instructor = await db.User.findOne({
            where: { user_type: "i" },
            order: db.sequelize.random()
        });
        
        if (!instructor) {
            throw new StudentCourseError('No instructors available', 500);
        }
        
        // Create the enrollment with transaction
        const createdStudentCourse = await withTransaction(async (transaction) => {
            const newStudentCourse = {
                ...req.body,
                userId: req.userId,
                instructorId: instructor.id,
                status: "i",
                startDate: req.body.startDate || new Date()
            };
            
            const studentCourse = await db.StudentCourse.create(newStudentCourse, { transaction });
            
            // Create student assessments for all course assessments
            const courseAssessments = await db.Assessment.findAll({
                where: { course_id: courseId }
            });
            
            if (courseAssessments.length > 0) {
                const studentAssessments = courseAssessments.map(assessment => ({
                    student_courseId: studentCourse.id,
                    assessmentId: assessment.id
                }));
                
                await db.StudentAssessment.bulkCreate(studentAssessments, { transaction });
            }
            
            return studentCourse;
        });
        
        // Fetch the complete enrollment with associations
       
        
        res.status(201).json(newStudentCourse);
        
    } catch (error) {
        console.error('Error creating student course:', error);
        
        if (error instanceof StudentCourseError) {
            return res.status(error.statusCode).json({
                success: false,
                message: error.message,
                details: error.details
            });
        }
        
        // Handle Sequelize validation errors
        if (error.name === 'SequelizeValidationError') {
            return res.status(400).json({
                success: false,
                message: 'Validation error',
                errors: error.errors.map(e => ({ field: e.path, message: e.message }))
            });
        }
        
        // Handle unique constraint violations
        if (error.name === 'SequelizeUniqueConstraintError') {
            return res.status(409).json({
                success: false,
                message: 'Duplicate entry',
                errors: error.errors.map(e => ({ field: e.path, message: e.message }))
            });
        }
        
        res.status(500).json({
            success: false,
            message: 'Error creating student course',
            error: process.env.NODE_ENV === 'development' ? error.message : 'Internal server error'
        });
    }
});

/**
 * PUT /student-courses/:id
 * Update a student course enrollment
 */
router.put("/:id", authenticate, async (req, res) => {
    try {
        const id = validateId(req.params.id, 'student course ID');
        
        // Validate status if provided
        if (req.body.status) {
            validateStatus(req.body.status);
        }
        
        // Find existing student course
        const existingStudentCourse = await db.StudentCourse.findOne({
            where: {
                id,
                userId: req.userId
            }
        });
        
        if (!existingStudentCourse) {
            throw new StudentCourseError('Student course not found or access denied', 404);
        }
        
        // Prevent certain status transitions
        if (existingStudentCourse.status === 'c' && req.body.status !== 'c') {
            throw new StudentCourseError('Cannot change status of completed course', 400);
        }
        
        // Validate dates if provided
        if (req.body.startDate && req.body.endDate) {
            const startDate = new Date(req.body.startDate);
            const endDate = new Date(req.body.endDate);
            
            if (endDate <= startDate) {
                throw new StudentCourseError('End date must be after start date', 400);
            }
        }
        
        // Don't allow changing critical fields
        const protectedFields = ['id', 'userId', 'courseId'];
        const updateData = { ...req.body };
        protectedFields.forEach(field => delete updateData[field]);
        
        // Update the record
        await existingStudentCourse.update(updateData);
        
               
        res.status(200).json(existingStudentCourse);
        
    } catch (error) {
        console.error('Error updating student course:', error);
        
        if (error instanceof StudentCourseError) {
            return res.status(error.statusCode).json({
                success: false,
                message: error.message,
                details: error.details
            });
        }
        
        // Handle Sequelize validation errors
        if (error.name === 'SequelizeValidationError') {
            return res.status(400).json({
                success: false,
                message: 'Validation error',
                errors: error.errors.map(e => ({ field: e.path, message: e.message }))
            });
        }
        
        res.status(500).json({
            success: false,
            message: 'Error updating student course',
            error: process.env.NODE_ENV === 'development' ? error.message : 'Internal server error'
        });
    }
});

router.use((error, req, res, next) => {
    console.error('Unhandled error in student-courses router:', error);
    
    res.status(error.statusCode || 500).json({
        success: false,
        message: error.message || 'Internal server error',
        ...(process.env.NODE_ENV === 'development' && { stack: error.stack })
    });
});

export default router;