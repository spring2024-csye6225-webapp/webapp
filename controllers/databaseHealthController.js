const sequelize = require("../models");
const students = require("../models/Students");
let databaseStatus = 503;
const databaseConnection = async () => {
  try {
    await sequelize.authenticate();
    await sequelize.sync();
    databaseStatus = 200;
  } catch (err) {
    console.log("database connection error", err);
    databaseStatus = 503;
  }
};

const healthCheck = async (req, res) => {
  console.log("the request body ", req.body);
  if (Object.keys(req.body).length > 0) {
    res.status(400).sendStatus("");
  } else {
    await databaseConnection();
    res.status(databaseStatus).send("");
  }
};

module.exports = { healthCheck };
