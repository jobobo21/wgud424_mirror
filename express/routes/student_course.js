// routes/student-courses.js
import { Op, Sequelize, where } from 'sequelize';
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

router.get('/upcomming', authenticate, async (req, res) => {
    try {
        //get user info
        var user = await db.User.findByPk(req.userId, {
            attributes: ["first_name", "last_name", "email", "program_id"],
        });
        user = user.toJSON();
        //get all student courses that are not elligable to add
        var studentCourses = await db.StudentCourse.findAll({
            where: {
                userId: req.userId,
                status: {[Op.in]: ["c", "a"]}
            },
            attributes: ["courseId"]
        })
        var studentCourseIds = studentCourses.map(sc => sc.toJSON().courseId);

        // query all courses in program
        var courses = await db.ProgramCourse.findAll({
            where: {
                program_id: user.program_id,
                id: {
                    [Op.notIn]: studentCourseIds
                }
            },
            include:[{model: db.Course, as: "course"
            }]
        })
        

        res.status(200).json(courses.map(c => {
            c = c.toJSON();
            return {...c.course, program_id: c.program_id}
        }));

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

        var studentCourse = await db.StudentCourse.findOne({
            where: {
                id: parseInt(id),
                userId: req.userId
            },
            include: [
                {
                    model: db.Course,
                    as: 'Course',
                    attributes: ['id', 'name', 'code', 'competency_units', 'assessment_type', 'description'],

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
                        attributes: ['id', 'name', 'type', 'description', 'max_attempts', 'is_proctored', 'sequence_order', 'passing_score', 'time_limit_minutes']
                    }
                }
            ]
        });

        if (!studentCourse) {
            return res.status(404).json({
                success: false,
                message: 'Student course not found'
            });
        }

        // Fetch student assessments separately to avoid association issues
        const studentAssessments = await db.StudentAssessment.findAll({
            where: {
                student_courseId: parseInt(id)
            },
            attributes: ['student_assessmentId', 'assessmentId', 'startDate', 'endDate']
        });

        // Enhance assessments with student progress
        // console.log("\n\n\n\nmade it this far!!\n\n\n\n");
        if (studentCourse.Course && studentCourse.Course.assessments) {

            studentCourse.Test = "Row 134";
            var assessments = await Promise.all(studentCourse.Course.assessments
                .map(async assessment => {
                    console.log()
                    const studentAssessment = studentAssessments.find(
                        sa => sa.assessmentId === assessment.id
                    );
                    console.log(`\n\n\n\nmade it this far!! ${JSON.stringify(studentAssessment)}\n\n\n\n`);
                    return {
                        ...assessment.toJSON(),
                        studentAssessment
                    };
                })).then((ta) => {
                    var sc = studentCourse.toJSON();
                    sc.StudentAssessments = ta
                    res.status(200).json(sc);
                });

        } else {
            res.status(200).json(studentCourse);
        }



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
router.delete("/:id", authenticate, async (req, res) => {
    var status = await db.StudentCourse.destroy({
        where: {
            id: req.params.id
        }
    })
    res.status(200).json(status)
})
router.post("/", authenticate, async(req, res) => {
    var newStudentCourse = req.body;
    newStudentCourse.userId = req.userId;
    console.log("\n\n\n\n creating studentCourse"+JSON.stringify(req.body)+"\n\n\n\n\n");
    const instructor = await db.User.findOne({ where:{
        user_type: "i"
    }, order: db.sequelize.random() })
    newStudentCourse.instructorId = instructor.id;
    newStudentCourse.status = "i";
    const createdStudentCourse = await db.StudentCourse.create(newStudentCourse);

    const courseAssessments = await db.Assessment.findAll({where: {course_id: newStudentCourse.courseId}});
    courseAssessments.forEach(ca => {
        ca = ca.toJSON();
        db.StudentAssessment.create({
            student_courseId: createdStudentCourse.id,
            assessmentId :ca.id,
        })
    });
    res.status(200).json(createdStudentCourse);
})

export default router;