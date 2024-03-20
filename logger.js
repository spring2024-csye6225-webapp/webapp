let winston = require("winston");

const logger = winston.createLogger({
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.json()
  ),
  transports: [
    new winston.transports.File({
      filename:
        process.env.NODE_ENV == "dev"
          ? "webappLogger.log"
          : "/var/log/webapp/webappLogger.log",
    }),
    // new LoggingWinston({
    //   projectId: "velvety-ground-414100",
    //   keyFilename: "",
    // }),
  ],
});

module.exports = logger;
