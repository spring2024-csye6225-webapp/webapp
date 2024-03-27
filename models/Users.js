const { DataTypes } = require("sequelize");
const sequelize = require("./index");

const Users = sequelize.define(
  "users",
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
    userVerified: {
      type: DataTypes.BOOLEAN, // Assuming userVerified is a boolean field
      defaultValue: false, // Set default value to false
    },
  },
  {
    freezeTableName: true,
    createdAt: "account_created",
    updatedAt: "account_updated",
  }
);

module.exports = Users;
