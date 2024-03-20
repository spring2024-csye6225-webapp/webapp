let express = require("express");
const nocache = require("nocache");
const databaseConnection = require("./controllers/databaseHealthController");
const bcrypt = require("bcrypt");
const students = require("./models/Users");
const logger = require("./logger");

let app = express();
app.use(nocache());
app.use(express.json());

app.get("/healthz", async function (req, res) {
  console.log("request params", req.query);
  console.log("the request body ", req.body);
  if (Object.keys(req.body).length > 0) {
    res.sendStatus(405);
  } else {
    databaseConnection.healthCheck(req, res);
  }
});

app.get("/healthz/:id", function (req, res) {
  if (req.params.id) {
    logger.warn("get request not allowed with id", { severity: "warn" });
    res.status(400).send("");
  }
});

app.use("/healthz", (req, res, next) => {
  if (req.method !== "GET" || req.method == "HEAD") {
    logger.info("no methods allowed apart from GET request", {
      severity: "error",
    });
    return res.status(405).send("Method Not Allowed");
  } else {
    next();
  }
});

app.post("/v1/user", async function (req, res) {
  let {
    first_name: firstname,
    last_name: lastname,
    username: email,
    password,
  } = req.body;
  let transformedData = {
    firstname,
    lastname,
    email,
    password,
  };
  let emailStatus = false;
  let emailFormat = /^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/;
  if (
    transformedData.email !== "" &&
    transformedData.email.match(emailFormat)
  ) {
    emailStatus = true;
  }
  if (emailStatus) {
    let userFind = await students.findOne({
      where: { email: transformedData.email },
    });
    if (userFind == null) {
      let hashedPassword = "";
      //generating hash password
      bcrypt.genSalt(10, async (err, salt) => {
        bcrypt.hash(transformedData.password, salt, async function (err, hash) {
          hashedPassword = hash;
          transformedData = { ...transformedData, password: hash };
          console.log("the trans data", transformedData);
          let userRecord = await students.create(transformedData);
          let userFind = await students.findOne({
            where: { email: userRecord.dataValues.email },
            attributes: { exclude: ["password"] },
          });
          if (userFind) {
            logger.debug("user creation debug", { severity: "debug" });
            logger.info("user created successfully", { severity: "info" });
            console.log("created successfully");
            res.status(201).send(userFind.dataValues);
          }
        });
      });
    } else {
      logger.info("user created failed", { severity: "error" });
      res.status(400).send("");
    }
  } else {
    res
      .status(400)
      .send(
        "Enter the email address in the correct format like  abc@gmail.com"
      );
  }
});

app.put("/v1/user/self", async function (req, res) {
  if (Object.keys(req.body).length == 0) {
    res.status(204).send("");
  } else {
    let {
      first_name: firstname,
      last_name: lastname,
      username: email,
      password,
    } = req.body;
    let transformedData = {
      firstname,
      lastname,
      email,
      password,
    };

    if (transformedData.email) {
      res.status(400).send("");
    } else {
      const authHeaders = req.headers.authorization;
      const userEmail = Buffer.from(authHeaders.split(" ")[1], "base64")
        .toString("utf-8")
        .split(":")[0];
      const userPassword = Buffer.from(authHeaders.split(" ")[1], "base64")
        .toString("utf-8")
        .split(":")[1];
      let userFind = await students.findOne({
        where: { email: userEmail },
      });
      if (userFind) {
        //check if the password matches
        const result = await bcrypt.compare(
          userPassword,
          userFind.dataValues.password
        );
        if (!result) {
          res.status(401).send("");
        } else {
          bcrypt.genSalt(10, async (err, salt) => {
            bcrypt.hash(
              transformedData.password,
              salt,
              async function (err, hash) {
                transformedData.password = hash;
                const updateRecord = await students.update(transformedData, {
                  where: { email: userEmail },
                });
                if (updateRecord) {
                  let userFind = await students.findOne({
                    where: { email: userEmail },
                    attributes: { exclude: "password" },
                  });
                  res.status(200).send(userFind.dataValues);
                  logger.info("user updation successfull", {
                    severity: "info",
                  });
                }
              }
            );
          });
        }
      } else {
        res.status(400).send("");
        logger.info("user updation failed", { severity: "error" });
      }
    }
  }
});

app.get("/v1/user/self", async function (req, res) {
  const authHeaders = req.headers.authorization;
  const userEmail = Buffer.from(authHeaders.split(" ")[1], "base64")
    .toString("utf-8")
    .split(":")[0];
  const userPassword = Buffer.from(authHeaders.split(" ")[1], "base64")
    .toString("utf-8")
    .split(":")[1];
  let userFind = await students.findOne({
    where: { email: userEmail },
  });
  console.log("the userfind", userFind);
  if (userFind) {
    const result = await bcrypt.compare(
      userPassword,
      userFind.dataValues.password
    );
    if (!result) {
      res.status(400).send("");
    } else {
      const newDataValues = Object.assign({}, userFind.dataValues);
      delete newDataValues.password;
      res.status(200).send(newDataValues);
      logger.info("user record fetched successfully", { severity: "info" });
    }
  } else {
    res.status(400).send("");
    logger.info("user record fetch failed", { severity: "error" });
  }
});

let server = app.listen(8080, function () {
  console.log("the app is running on the port 8080");
});

function startServer() {
  return server;
}

module.exports = { app, startServer };
