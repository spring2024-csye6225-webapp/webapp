const { Sequelize } = require("sequelize");

const sequelize = new Sequelize(
  "cloudusers",
  "abhaydeshpande",
  "abhaydeshpande",
  {
    host: "localhost",
    dialect: "postgres",
  }
);

module.exports = sequelize;
