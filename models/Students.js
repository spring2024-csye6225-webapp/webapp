const { DataTypes } = require("sequelize");
const sequelize = require("./index");

const students = sequelize.define(
  "students",
  {
    firstname: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    lastname: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    email: {
      type: DataTypes.STRING,
      allowNull: false,
      unique: true,
    },
    password: {
      type: DataTypes.STRING,
      allowNull: false,
    },
  },
  {
    freezeTableName: true,
    createdAt: "account_created",
    updatedAt: "account_updated",
  }
);

module.exports = students;
