// Assessment Types Model
import { DataTypes } from "sequelize";
export default function (sequelize) {
    var User = sequelize.define('User', {
        id: {
            type: DataTypes.INTEGER,
            primaryKey: true,
            autoIncrement: false
        },
        email: {
            type: DataTypes.STRING(45),
            allowNull: false,
            validate: {
                notEmpty: true
            }
        },
        first_name: {
            type: DataTypes.STRING(45),
            allowNull: false,
            validate: {
                notEmpty: true
            }
        },
        last_name: {
            type: DataTypes.STRING(45),
            allowNull: false,
            validate: {
                notEmpty: true
            }
        },
        user_type: {
            type: DataTypes.STRING(10),
            allowNull: false,
            validate: {
                notEmpty: true
            }
        },
        program_id: {
            type: DataTypes.INTEGER,
            allowNull: true,
        },
        mentor_id: {
            type: DataTypes.INTEGER,
            allowNull: true
        },
        password: {
            type: DataTypes.STRING(100),
            allowNull: false,
            validate: {
                notEmpty: true
            }
        },
        grad_date: {
            type: DataTypes.DATE,
            allowNull: true,

        },

    },

        {
            tableName: 'users',
            timestamps: true,
            createdAt: 'created_at',
            updatedAt: 'updated_at',
            underscored: true
        });
    User.associate = function (models) {
        // User belongs to Program (student enrollment)
        User.belongsTo(models.Program, {
            foreignKey: 'program_id',
            as: 'program'
        });
    }
    return User;
};