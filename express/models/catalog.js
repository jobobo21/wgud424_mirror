// WGU Database Sequelize v6 Models (using sequelize.define)
// Compatible with "sequelize": "^6.37.7" and "type": "module"
// Dependencies: sequelize, mysql2

import { DataTypes } from 'sequelize';

// College Model
export const College = (sequelize) => {
  return sequelize.define('College', {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: false // Using manual IDs as per your data
    },
    name: {
      type: DataTypes.STRING(100),
      allowNull: false,
      validate: {
        notEmpty: true
      }
    },
    code: {
      type: DataTypes.STRING(10),
      allowNull: false,
      unique: true,
      validate: {
        notEmpty: true
      }
    },
    description: {
      type: DataTypes.TEXT,
      allowNull: true
    }
  }, {
    tableName: 'colleges',
    timestamps: true,
    createdAt: 'created_at',
    updatedAt: 'updated_at',
    underscored: true
  });
};

// Assessment Types Model
export const AssessmentType = (sequelize) => {
  return sequelize.define('AssessmentType', {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: false
    },
    name: {
      type: DataTypes.STRING(50),
      allowNull: false,
      validate: {
        notEmpty: true
      }
    },
    description: {
      type: DataTypes.TEXT,
      allowNull: true
    }
  }, {
    tableName: 'assessment_types',
    timestamps: true,
    createdAt: 'created_at',
    updatedAt: false,
    underscored: true
  });
};

// Competency Categories Model
export const CompetencyCategory = (sequelize) => {
  return sequelize.define('CompetencyCategory', {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: false
    },
    name: {
      type: DataTypes.STRING(50),
      allowNull: false,
      validate: {
        notEmpty: true
      }
    },
    description: {
      type: DataTypes.TEXT,
      allowNull: true
    }
  }, {
    tableName: 'competency_categories',
    timestamps: true,
    createdAt: 'created_at',
    updatedAt: false,
    underscored: true
  });
};

// Program Model
export const Program = (sequelize) => {
  return sequelize.define('Program', {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: false
    },
    name: {
      type: DataTypes.STRING(150),
      allowNull: false,
      validate: {
        notEmpty: true
      }
    },
    code: {
      type: DataTypes.STRING(20),
      allowNull: false,
      unique: true,
      validate: {
        notEmpty: true
      }
    },
    degree_level: {
      type: DataTypes.ENUM('Certificate', 'Bachelor', 'Master', 'Doctoral'),
      allowNull: false
    },
    college_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: 'colleges',
        key: 'id'
      }
    },
    total_competency_units: {
      type: DataTypes.INTEGER,
      allowNull: false,
      validate: {
        min: 1
      }
    },
    tuition_per_term: {
      type: DataTypes.DECIMAL(8, 2),
      allowNull: false,
      validate: {
        min: 0
      }
    },
    is_active: {
      type: DataTypes.BOOLEAN,
      defaultValue: true
    }
  }, {
    tableName: 'programs',
    timestamps: true,
    createdAt: 'created_at',
    updatedAt: 'updated_at',
    underscored: true,
    scopes: {
      active: {
        where: { is_active: true }
      },
      bachelor: {
        where: { degree_level: 'Bachelor' }
      },
      master: {
        where: { degree_level: 'Master' }
      },
      byCollege: (collegeId) => ({
        where: { college_id: collegeId }
      })
    }
  });
};

// Course Model
export function Course(sequelize) {
  return sequelize.define('Course', {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: false
    },
    name: {
      type: DataTypes.STRING(200),
      allowNull: false,
      validate: {
        notEmpty: true
      }
    },
    code: {
      type: DataTypes.STRING(20),
      allowNull: false,
      unique: true,
      validate: {
        notEmpty: true
      }
    },
    competency_units: {
      type: DataTypes.INTEGER,
      allowNull: false,
      validate: {
        min: 1,
        max: 10
      }
    },
    assessment_type: {
      type: DataTypes.ENUM('Objective', 'Performance', 'Mixed'),
      allowNull: false
    },
    description: {
      type: DataTypes.TEXT,
      allowNull: true
    },
    competency_category_id: {
      type: DataTypes.INTEGER,
      defaultValue: 1,
      references: {
        model: 'competency_categories',
        key: 'id'
      }
    },
    is_active: {
      type: DataTypes.BOOLEAN,
      defaultValue: true
    }
  }, {
    tableName: 'courses',
    timestamps: true,
    createdAt: 'created_at',
    updatedAt: 'updated_at',
    underscored: true,
    scopes: {
      active: {
        where: { is_active: true }
      },
      objective: {
        where: { assessment_type: 'Objective' }
      },
      performance: {
        where: { assessment_type: 'Performance' }
      },
      mixed: {
        where: { assessment_type: 'Mixed' }
      }
    }
  });
};

// Program Courses Junction Model
export const ProgramCourse = (sequelize) => {
  return sequelize.define('ProgramCourse', {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    program_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: 'programs',
        key: 'id'
      }
    },
    course_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: 'courses',
        key: 'id'
      }
    },
    sequence_order: {
      type: DataTypes.INTEGER,
      allowNull: false,
      validate: {
        min: 1
      }
    },
    is_required: {
      type: DataTypes.BOOLEAN,
      defaultValue: true
    },
    competency_category_id: {
      type: DataTypes.INTEGER,
      defaultValue: 1,
      references: {
        model: 'competency_categories',
        key: 'id'
      }
    }
  }, {
    tableName: 'program_courses',
    timestamps: true,
    createdAt: 'created_at',
    updatedAt: false,
    underscored: true,
    indexes: [
      {
        unique: true,
        fields: ['program_id', 'course_id']
      },
      {
        unique: true,
        fields: ['program_id', 'sequence_order']
      }
    ]
  });
};

// Prerequisites Model
export const Prerequisite = (sequelize) => {
  return sequelize.define('Prerequisite', {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    course_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: 'courses',
        key: 'id'
      }
    },
    prerequisite_course_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: 'courses',
        key: 'id'
      }
    },
    is_required: {
      type: DataTypes.BOOLEAN,
      defaultValue: true
    }
  }, {
    tableName: 'prerequisites',
    timestamps: true,
    createdAt: 'created_at',
    updatedAt: false,
    underscored: true,
    indexes: [
      {
        unique: true,
        fields: ['course_id', 'prerequisite_course_id']
      }
    ]
  });
};

// Assessment Model
export const Assessment = (sequelize) => {
  return sequelize.define('Assessment', {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    course_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: 'courses',
        key: 'id'
      }
    },
    name: {
      type: DataTypes.STRING(200),
      allowNull: false,
      validate: {
        notEmpty: true
      }
    },
    type: {
      type: DataTypes.ENUM('O', 'P'),
      allowNull: false,
      validate: {
        isIn: [['O', 'P']]
      }
    },
    description: {
      type: DataTypes.TEXT,
      allowNull: true
    },
    passing_score: {
      type: DataTypes.DECIMAL(5, 2),
      allowNull: true,
      validate: {
        min: 0,
        max: 100
      }
    },
    max_attempts: {
      type: DataTypes.INTEGER,
      defaultValue: 3,
      validate: {
        min: 1
      }
    },
    time_limit_minutes: {
      type: DataTypes.INTEGER,
      allowNull: true,
      validate: {
        min: 1
      }
    },
    is_proctored: {
      type: DataTypes.BOOLEAN,
      defaultValue: false
    },
    is_required_to_pass: {
      type: DataTypes.BOOLEAN,
      defaultValue: true
    },
    sequence_order: {
      type: DataTypes.INTEGER,
      defaultValue: 1,
      validate: {
        min: 1
      }
    },
    is_active: {
      type: DataTypes.BOOLEAN,
      defaultValue: true
    }
  }, {
    tableName: 'assessments',
    timestamps: true,
    createdAt: 'created_at',
    updatedAt: 'updated_at',
    underscored: true,
    indexes: [
      {
        unique: true,
        fields: ['course_id', 'sequence_order']
      }
    ],
    scopes: {
      active: {
        where: { is_active: true }
      },
      objective: {
        where: { type: 'O' }
      },
      performance: {
        where: { type: 'P' }
      },
      proctored: {
        where: { is_proctored: true }
      },
      required: {
        where: { is_required_to_pass: true }
      }
    }
  });
};

// Define associations function
export const defineAssociations = (models) => {
  const { College, Program, Course, ProgramCourse, Prerequisite, Assessment, CompetencyCategory, AssessmentType } = models;

  // College associations
  College.hasMany(Program, { 
    foreignKey: 'college_id', 
    as: 'programs' 
  });
  Program.belongsTo(College, { 
    foreignKey: 'college_id', 
    as: 'college' 
  });

  // Program-Course many-to-many through ProgramCourse
  Program.belongsToMany(Course, {
    through: ProgramCourse,
    foreignKey: 'program_id',
    otherKey: 'course_id',
    as: 'courses'
  });
  Course.belongsToMany(Program, {
    through: ProgramCourse,
    foreignKey: 'course_id',
    otherKey: 'program_id',
    as: 'programs'
  });

  // Direct associations for ProgramCourse
  Program.hasMany(ProgramCourse, {
    foreignKey: 'program_id',
    as: 'programCourses'
  });
  Course.hasMany(ProgramCourse, {
    foreignKey: 'course_id',
    as: 'programCourses'
  });
  ProgramCourse.belongsTo(Program, {
    foreignKey: 'program_id',
    as: 'program'
  });
  ProgramCourse.belongsTo(Course, {
    foreignKey: 'course_id',
    as: 'course'
  });

  // Prerequisites self-referential association
  Course.hasMany(Prerequisite, {
    foreignKey: 'course_id',
    as: 'prerequisites'
  });
  Course.hasMany(Prerequisite, {
    foreignKey: 'prerequisite_course_id',
    as: 'dependentCourses'
  });
  Prerequisite.belongsTo(Course, {
    foreignKey: 'course_id',
    as: 'course'
  });
  Prerequisite.belongsTo(Course, {
    foreignKey: 'prerequisite_course_id',
    as: 'prerequisiteCourse'
  });

  // Course-Assessment association
  Course.hasMany(Assessment, {
    foreignKey: 'course_id',
    as: 'assessments'
  });
  Assessment.belongsTo(Course, {
    foreignKey: 'course_id',
    as: 'course'
  });

  // Competency Category associations
  CompetencyCategory.hasMany(Course, {
    foreignKey: 'competency_category_id',
    as: 'courses'
  });
  Course.belongsTo(CompetencyCategory, {
    foreignKey: 'competency_category_id',
    as: 'competencyCategory'
  });

  CompetencyCategory.hasMany(ProgramCourse, {
    foreignKey: 'competency_category_id',
    as: 'programCourses'
  });
  ProgramCourse.belongsTo(CompetencyCategory, {
    foreignKey: 'competency_category_id',
    as: 'competencyCategory'
  });
};


// Export everything for easy importing
