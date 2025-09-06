// models/StudentAssessment.js
import { DataTypes } from 'sequelize';

export default function(sequelize) {
    const StudentAssessment = sequelize.define('StudentAssessment', {
        student_assessmentId: {
            type: DataTypes.INTEGER,
            primaryKey: true,
            autoIncrement: true,
            allowNull: false,
            field: 'student_assessmentId'
        },
        student_courseId: {
            type: DataTypes.INTEGER,
            allowNull: true,
            references: {
                model: 'student_course',
                key: 'id'
            },
            field: 'student_courseId'
        },
        assessmentId: {
            type: DataTypes.INTEGER,
            allowNull: true,
            references: {
                model: 'assessments',
                key: 'id'
            },
            field: 'assessmentId'
        },
        startDate: {
            type: DataTypes.DATE,
            allowNull: true,
            field: 'startDate'
        },
        endDate: {
            type: DataTypes.DATE,
            allowNull: true,
            field: 'endDate'
        }
    }, {
        tableName: 'student_assessment',
        timestamps: false, // No created_at/updated_at columns in this table
        underscored: false, // Keep field names as defined
        indexes: [
            {
                name: 'idx_student_assessment_student_course',
                fields: ['student_courseId']
            },
            {
                name: 'idx_student_assessment_assessment',
                fields: ['assessmentId']
            },
            {
                name: 'idx_student_assessment_dates',
                fields: ['startDate', 'endDate']
            }
        ]
    });

    // Define associations
    StudentAssessment.associate = function(models) {
        // Belongs to StudentCourse
        StudentAssessment.belongsTo(models.StudentCourse, {
            foreignKey: 'student_courseId',
            as: 'StudentCourse',
            onDelete: 'CASCADE'
        });

        // Belongs to Assessment
        StudentAssessment.belongsTo(models.Assessment, {
            foreignKey: 'assessmentId',
            as: 'Assessment',
            onDelete: 'CASCADE'
        });
    };

    // Instance methods
    StudentAssessment.prototype.isCompleted = function() {
        return this.endDate !== null;
    };

    StudentAssessment.prototype.isInProgress = function() {
        return this.startDate !== null && this.endDate === null;
    };

    StudentAssessment.prototype.getDuration = function() {
        if (!this.isCompleted()) {
            return null;
        }
        return new Date(this.endDate) - new Date(this.startDate);
    };

    StudentAssessment.prototype.getDurationInDays = function() {
        const duration = this.getDuration();
        if (!duration) return null;
        return Math.ceil(duration / (1000 * 60 * 60 * 24));
    };

    // Class methods
    StudentAssessment.findByUserId = async function(userId, options = {}) {
        return await this.findAll({
            include: [
                {
                    model: sequelize.models.StudentCourse,
                    as: 'StudentCourse',
                    where: { userId: userId },
                    required: true,
                    ...options.studentCourseOptions
                },
                {
                    model: sequelize.models.Assessment,
                    as: 'Assessment',
                    ...options.assessmentOptions
                }
            ],
            ...options.queryOptions
        });
    };

    StudentAssessment.findCompletedByUserId = async function(userId, options = {}) {
        return await this.findByUserId(userId, {
            ...options,
            queryOptions: {
                where: {
                    endDate: { [sequelize.Sequelize.Op.not]: null }
                },
                order: [['endDate', 'DESC']],
                ...options.queryOptions
            }
        });
    };

    StudentAssessment.findInProgressByUserId = async function(userId, options = {}) {
        return await this.findByUserId(userId, {
            ...options,
            queryOptions: {
                where: {
                    startDate: { [sequelize.Sequelize.Op.not]: null },
                    endDate: null
                },
                order: [['startDate', 'ASC']],
                ...options.queryOptions
            }
        });
    };

    StudentAssessment.findByCourseAndUserId = async function(courseId, userId, options = {}) {
        return await this.findAll({
            include: [
                {
                    model: sequelize.models.StudentCourse,
                    as: 'StudentCourse',
                    where: { 
                        userId: userId,
                        courseId: courseId
                    },
                    required: true
                },
                {
                    model: sequelize.models.Assessment,
                    as: 'Assessment',
                    ...options.assessmentOptions
                }
            ],
            order: [[sequelize.models.Assessment, 'sequence_order', 'ASC']],
            ...options.queryOptions
        });
    };

    StudentAssessment.getAssessmentStats = async function(userId) {
        const stats = await this.findAll({
            include: [
                {
                    model: sequelize.models.StudentCourse,
                    as: 'StudentCourse',
                    where: { userId: userId },
                    required: true
                },
                {
                    model: sequelize.models.Assessment,
                    as: 'Assessment',
                    attributes: ['type']
                }
            ],
            attributes: [
                [sequelize.fn('COUNT', sequelize.col('student_assessmentId')), 'total'],
                [sequelize.fn('COUNT', sequelize.literal('CASE WHEN endDate IS NOT NULL THEN 1 END')), 'completed'],
                [sequelize.fn('COUNT', sequelize.literal('CASE WHEN startDate IS NOT NULL AND endDate IS NULL THEN 1 END')), 'inProgress'],
                [sequelize.fn('COUNT', sequelize.literal('CASE WHEN Assessment.type = "O" THEN 1 END')), 'objective'],
                [sequelize.fn('COUNT', sequelize.literal('CASE WHEN Assessment.type = "P" THEN 1 END')), 'performance']
            ],
            raw: true
        });

        return stats[0] || {
            total: 0,
            completed: 0,
            inProgress: 0,
            objective: 0,
            performance: 0
        };
    };

    // Validation
    StudentAssessment.addHook('beforeValidate', (studentAssessment, options) => {
        // Ensure endDate is after startDate if both are provided
        if (studentAssessment.startDate && studentAssessment.endDate) {
            if (new Date(studentAssessment.endDate) <= new Date(studentAssessment.startDate)) {
                throw new Error('End date must be after start date');
            }
        }
    });

    // Scopes
    StudentAssessment.addScope('completed', {
        where: {
            endDate: { [sequelize.Sequelize.Op.not]: null }
        }
    });

    StudentAssessment.addScope('inProgress', {
        where: {
            startDate: { [sequelize.Sequelize.Op.not]: null },
            endDate: null
        }
    });

    StudentAssessment.addScope('notStarted', {
        where: {
            startDate: null
        }
    });

    StudentAssessment.addScope('withCourse', {
        include: [
            {
                model: sequelize.models.StudentCourse,
                as: 'StudentCourse',
                include: [
                    {
                        model: sequelize.models.Course,
                        as: 'Course'
                    }
                ]
            }
        ]
    });

    StudentAssessment.addScope('withAssessment', {
        include: [
            {
                model: sequelize.models.Assessment,
                as: 'Assessment'
            }
        ]
    });

    StudentAssessment.addScope('withFullDetails', {
        include: [
            {
                model: sequelize.models.StudentCourse,
                as: 'StudentCourse',
                include: [
                    {
                        model: sequelize.models.Course,
                        as: 'Course'
                    },
                    {
                        model: sequelize.models.User,
                        as: 'Instructor'
                    },
                    {
                        model: sequelize.models.Term,
                        as: 'Term'
                    }
                ]
            },
            {
                model: sequelize.models.Assessment,
                as: 'Assessment'
            }
        ]
    });

    return StudentAssessment;
}

