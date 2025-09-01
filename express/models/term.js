// models/Terms.js
import { DataTypes } from 'sequelize';

export default (sequelize) => {
  const Term = sequelize.define('Term', {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
      allowNull: false,
      comment: 'Primary key for terms table'
    },
    term_no: {
      type: DataTypes.INTEGER,
      allowNull: true,
      comment: 'Term number identifier'
    },
    startDate: {
      type: DataTypes.DATE,
      allowNull: true,
      field: 'startDate',
      comment: 'Term start date'
    },
    endDate: {
      type: DataTypes.DATE,
      allowNull: true,
      field: 'endDate', 
      comment: 'Term end date'
    },
    student_id: {
      type: DataTypes.INTEGER,
      allowNull: true,
      comment: 'Foreign key reference to student (users table)'
    }
  }, {
    tableName: 'terms',
    timestamps: false,
    indexes: [
      {
        fields: ['student_id'],
        name: 'idx_terms_student_id'
      },
      {
        fields: ['term_no'],
        name: 'idx_terms_term_no'
      },
      {
        fields: ['startDate', 'endDate'],
        name: 'idx_terms_date_range'
      }
    ]
  });

  Term.associate = (models) => {
    // Reference User (singular) to match your model naming convention
    if (models.User) {
      Term.belongsTo(models.User, {
        foreignKey: 'student_id',
        as: 'Student',
        targetKey: 'id'
      });
    }
    
    // Reference StudentCourse when available
    if (models.StudentCourse) {
      Term.hasMany(models.StudentCourse, {
        foreignKey: 'term_id',
        as: 'StudentCourses'
      });
    }
  };

  return Term;
};