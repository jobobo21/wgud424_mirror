// routes/courses.js
import express from 'express';
import { Op } from 'sequelize';
import DB from '../models/index.js';

const router = express.Router();

// Initialize models
const models = DB();
const {
  Course,
  Program,
  Assessment,
  CompetencyCategory,
  ProgramCourse,
  College,
  Prerequisite
} = models;

/**
 * GET /courses
 * Retrieve all courses with optional filtering
 * Query parameters:
 * - active: true/false (filter by active status)
 * - assessment_type: Objective/Performance/Mixed
 * - competency_category_id: number
 * - include_assessments: true/false
 * - include_programs: true/false
 * - page: number (for pagination)
 * - limit: number (for pagination)
 */
router.get('/', async (req, res) => {
  try {
    const {
      active,
      assessment_type,
      competency_category_id,
      include_assessments,
      include_programs,
      page = 1,
      limit = 50
    } = req.query;

    // Build where clause
    const where = {};
    if (active !== undefined) {
      where.is_active = active === 'true';
    }
    if (assessment_type) {
      where.assessment_type = assessment_type;
    }
    if (competency_category_id) {
      where.competency_category_id = parseInt(competency_category_id);
    }

    // Build include array
    const include = [];
    
    // Always include competency category
    include.push({
      model: CompetencyCategory,
      as: 'competencyCategory',
      attributes: ['id', 'name', 'description']
    });

    if (include_assessments === 'true') {
      include.push({
        model: Assessment,
        as: 'assessments',
        attributes: ['id', 'name', 'type', 'passing_score', 'max_attempts', 'is_proctored'],
        order: [['sequence_order', 'ASC']]
      });
    }

    if (include_programs === 'true') {
      include.push({
        model: Program,
        as: 'programs',
        attributes: ['id', 'name', 'code', 'degree_level'],
        through: {
          attributes: ['sequence_order', 'is_required']
        }
      });
    }

    // Calculate offset for pagination
    const offset = (parseInt(page) - 1) * parseInt(limit);

    const { count, rows: courses } = await Course.findAndCountAll({
      where,
      include,
      limit: parseInt(limit),
      offset,
      order: [['name', 'ASC']],
      distinct: true // Important for accurate count with includes
    });

    res.json({
      success: true,
      data: {
        courses,
        pagination: {
          total: count,
          page: parseInt(page),
          limit: parseInt(limit),
          totalPages: Math.ceil(count / parseInt(limit))
        }
      }
    });

  } catch (error) {
    console.error('Error retrieving courses:', error);
    res.status(500).json({
      success: false,
      message: 'Error retrieving courses',
      error: error.message
    });
  }
});

/**
 * GET /courses/:id
 * Retrieve a specific course by ID with full details
 */
router.get('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const { include_prerequisites } = req.query;

    const include = [
      {
        model: CompetencyCategory,
        as: 'competencyCategory',
        attributes: ['id', 'name', 'description']
      },
      {
        model: Assessment,
        as: 'assessments',
        attributes: ['id', 'name', 'type', 'description', 'passing_score', 'max_attempts', 'time_limit_minutes', 'is_proctored', 'sequence_order'],
        order: [['sequence_order', 'ASC']]
      },
      {
        model: Program,
        as: 'programs',
        attributes: ['id', 'name', 'code', 'degree_level'],
        through: {
          attributes: ['sequence_order', 'is_required', 'competency_category_id']
        }
      }
    ];

    // Add prerequisites if requested
    if (include_prerequisites === 'true') {
      include.push({
        model: Prerequisite,
        as: 'prerequisites',
        include: [{
          model: Course,
          as: 'prerequisiteCourse',
          attributes: ['id', 'name', 'code']
        }]
      });
    }

    const course = await Course.findByPk(id, {
      include
    });

    if (!course) {
      return res.status(404).json({
        success: false,
        message: 'Course not found'
      });
    }

    res.json({
      success: true,
      data: course
    });

  } catch (error) {
    console.error('Error retrieving course:', error);
    res.status(500).json({
      success: false,
      message: 'Error retrieving course',
      error: error.message
    });
  }
});

/**
 * GET /courses/code/:code
 * Retrieve a course by its code (e.g., "CS101")
 */
router.get('/code/:code', async (req, res) => {
  try {
    const { code } = req.params;

    const course = await Course.findOne({
      where: { code: code.toUpperCase() },
      include: [
        {
          model: CompetencyCategory,
          as: 'competencyCategory',
          attributes: ['id', 'name', 'description']
        },
        {
          model: Assessment,
          as: 'assessments',
          attributes: ['id', 'name', 'type', 'passing_score', 'max_attempts', 'is_proctored'],
          order: [['sequence_order', 'ASC']]
        }
      ]
    });

    if (!course) {
      return res.status(404).json({
        success: false,
        message: `Course with code ${code} not found`
      });
    }

    res.json({
      success: true,
      data: course
    });

  } catch (error) {
    console.error('Error retrieving course by code:', error);
    res.status(500).json({
      success: false,
      message: 'Error retrieving course by code',
      error: error.message
    });
  }
});

/**
 * GET /courses/:id/programs
 * Get all programs that include this course
 */
router.get('/:id/programs', async (req, res) => {
  try {
    const { id } = req.params;

    const course = await Course.findByPk(id, {
      include: [{
        model: Program,
        as: 'programs',
        attributes: ['id', 'name', 'code', 'degree_level', 'total_competency_units'],
        through: {
          attributes: ['sequence_order', 'is_required']
        },
        include: [{
          model: College,
          as: 'college',
          attributes: ['id', 'name', 'code']
        }]
      }]
    });

    if (!course) {
      return res.status(404).json({
        success: false,
        message: 'Course not found'
      });
    }

    res.json({
      success: true,
      data: {
        course_id: course.id,
        course_name: course.name,
        course_code: course.code,
        programs: course.programs
      }
    });

  } catch (error) {
    console.error('Error retrieving course programs:', error);
    res.status(500).json({
      success: false,
      message: 'Error retrieving course programs',
      error: error.message
    });
  }
});

/**
 * GET /courses/:id/assessments
 * Get all assessments for a specific course
 */
router.get('/:id/assessments', async (req, res) => {
  try {
    const { id } = req.params;
    const { active_only } = req.query;

    const whereClause = { course_id: id };
    if (active_only === 'true') {
      whereClause.is_active = true;
    }

    const assessments = await Assessment.findAll({
      where: whereClause,
      order: [['sequence_order', 'ASC']],
      include: [{
        model: Course,
        as: 'course',
        attributes: ['id', 'name', 'code']
      }]
    });

    res.json({
      success: true,
      data: {
        course_id: parseInt(id),
        assessments
      }
    });

  } catch (error) {
    console.error('Error retrieving course assessments:', error);
    res.status(500).json({
      success: false,
      message: 'Error retrieving course assessments',
      error: error.message
    });
  }
});

/**
 * GET /courses/search/:query
 * Search courses by name or description
 */
router.get('/search/:query', async (req, res) => {
  try {
    const { query } = req.params;
    const { limit = 20 } = req.query;

    const courses = await Course.findAll({
      where: {
        [Op.or]: [
          { name: { [Op.like]: `%${query}%` } },
          { description: { [Op.like]: `%${query}%` } },
          { code: { [Op.like]: `%${query}%` } }
        ]
      },
      include: [{
        model: CompetencyCategory,
        as: 'competencyCategory',
        attributes: ['id', 'name']
      }],
      limit: parseInt(limit),
      order: [['name', 'ASC']]
    });

    res.json({
      success: true,
      data: {
        query,
        results: courses.length,
        courses
      }
    });

  } catch (error) {
    console.error('Error searching courses:', error);
    res.status(500).json({
      success: false,
      message: 'Error searching courses',
      error: error.message
    });
  }
});

export default router;