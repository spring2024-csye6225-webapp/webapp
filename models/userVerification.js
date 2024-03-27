const { DataTypes } = require("sequelize");
const sequelize = require("./index");
const UserVerification = sequelize.define("usersverification", {
  uuid: {
    type: DataTypes.UUID, // Define the field type as UUID
    allowNull: false,
    defaultValue: sequelize.UUIDV4, // Generate UUIDv4 by default
    primaryKey: true, // Make it a primary key
  },
  email: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  createdAt: {
    type: DataTypes.DATE,
    allowNull: false,
    defaultValue: sequelize.literal("CURRENT_TIMESTAMP"),
  },
});

module.exports = UserVerification;
