let winston = require("winston");

const logger = winston.createLogger({
  format: winston.format.json(),
  transports: [
    new winston.transports.File({ filename: "/var/log/webappLogger.log" }),
    // new LoggingWinston({
    //   projectId: "velvety-ground-414100",
    //   keyFilename: "",
    // }),
  ],
});

module.exports = logger;
