const logger = require("../logger");
const sequelize = require("../models");
let databaseStatus = 503;
const databaseConnection = async () => {
  try {
    await sequelize.authenticate();
    await sequelize.sync();
    databaseStatus = 200;
    logger.info("database successfully connected", { severity: "info" });
  } catch (err) {
    logger.info("Database connection error", { severity: "error" });
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
