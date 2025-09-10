// models/StudentCourse.js
import { DataTypes } from 'sequelize';

export default (sequelize) => {
  const StudentCourse = sequelize.define('StudentCourse', {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
      allowNull: false,
      comment: 'Primary key for student_course table'
    },
    userId: {
      type: DataTypes.INTEGER,
      allowNull: true,
      comment: 'Foreign key reference to user (student)'
    },
    instructorId: {
      type: DataTypes.INTEGER,
      allowNull: true,
      comment: 'Foreign key reference to instructor user'
    },
    courseId: {
      type: DataTypes.INTEGER,
      allowNull: true,
      comment: 'Foreign key reference to course'
    },
    startDate: {
      type: DataTypes.DATE,
      allowNull: true,
      field: 'startDate',
      comment: 'Course enrollment start date'
    },
    endDate: {
      type: DataTypes.DATE,
      allowNull: true,
      field: 'endDate',
      comment: 'Course completion/end date'
    },
    status: {
      type: DataTypes.STRING(1),
      allowNull: true,
      comment: 'Course status: c=complete, a=active, etc.',
      validate: {
        isIn: [['c', 'a', 'i', 'w']] // common statuses: complete, active, incomplete, withdrawn
      }
    },
    term_id: {
      type: DataTypes.INTEGER,
      allowNull: true,
      comment: 'Foreign key reference to term'
    }
  }, {
    tableName: 'student_course',
    timestamps: false, 
    indexes: [
      {
        fields: ['userId'],
        name: 'idx_student_course_user'
      },
      {
        fields: ['courseId'],
        name: 'idx_student_course_course'
      },
      {
        fields: ['instructorId'],
        name: 'idx_student_course_instructor'
      },
      {
        fields: ['term_id'],
        name: 'idx_student_course_term'
      },
      {
        fields: ['status'],
        name: 'idx_student_course_status'
      },
      {
        fields: ['userId', 'courseId'],
        name: 'idx_student_course_user_course'
      }
    ]
  });

  StudentCourse.associate = (models) => {
    // Student course belongs to a user (student)
    if (models.User) {
      StudentCourse.belongsTo(models.User, {
        foreignKey: 'userId',
        as: 'Student'
      });

      // Student course belongs to an instructor (also a user)
      StudentCourse.belongsTo(models.User, {
        foreignKey: 'instructorId',
        as: 'Instructor'
      });
    }

    // Student course belongs to a course
    if (models.Course) {
      StudentCourse.belongsTo(models.Course, {
        foreignKey: 'courseId',
        as: 'Course'
      });
    }

    // Student course belongs to a term
    if (models.Term) {
      StudentCourse.belongsTo(models.Term, {
        foreignKey: 'term_id',
        as: 'Term'
      });
    }
    if (models.StudentAssessment) {
      StudentCourse.hasMany(models.StudentAssessment, {
        foreignKey: 'student_courseId',
        as: 'StudentAssessments'
      });
    }
  };

  return StudentCourse;
};