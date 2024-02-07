let express = require("express");
const nocache = require("nocache");
const databaseConnection = require("./controllers/databaseHealthController");
const bcrypt = require("bcrypt");
const students = require("./models/Students");
let app = express();
app.use(nocache());
app.use(express.json());

app.get("/healthz", function (req, res) {
  databaseConnection.healthCheck(req, res);
});

app.get("/healthz/:id", function (req, res) {
  if (req.params.id) {
    res.status(400).send("");
  }
});

app.put("/healthz", function (req, res) {
  res.status(405).send("");
});

app.delete("/healthz", function (req, res) {
  res.status(405).send("");
});

app.patch("/healthz", function (req, res) {
  res.status(405).send("");
});

app.post("/healthz", function (req, res) {
  res.status(405).send("");
});

app.head("/healthz", function (req, res) {
  res.status(405).send("");
});

app.options("/healthz", function (req, res) {
  res.status(405).send("");
});

app.post("/user", async function (req, res) {
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
        let userRecord = await students.create(transformedData);
        let userFind = await students.findOne({
          where: { email: userRecord.dataValues.email },
          attributes: { exclude: ["password"] },
        });
        if (userFind) {
          res.status(200).send(userFind.dataValues);
        }
      });
    });
  } else {
    res.status(400).send("");
  }
});

app.put("/user/self", async function (req, res) {
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

    let userFind = await students.findOne({
      where: { email: userEmail },
      attributes: { exclude: ["password"] },
    });
    if (userFind) {
      bcrypt.genSalt(10, async (err, salt) => {
        bcrypt.hash(transformedData.password, salt, async function (err, hash) {
          transformedData.password = hash;
          const updateRecord = await students.update(transformedData, {
            where: { email: userEmail },
          });
          if (updateRecord) {
            res.status(200).send("Records updated");
          }
        });
      });
    }
  }
});

app.get("/user/self", async function (req, res) {
  const authHeaders = req.headers.authorization;
  const userEmail = Buffer.from(authHeaders.split(" ")[1], "base64")
    .toString("utf-8")
    .split(":")[0];

  let userFind = await students.findOne({
    where: { email: userEmail },
    attributes: { exclude: ["password"] },
  });
  if (userFind) {
    res.status(200).send(userFind.dataValues);
  } else {
    res.status(400).send("");
  }
});
let server = app.listen(8080, function () {
  console.log("the app is running on the port 8080");
});

function startServer() {
  return server;
}

module.exports = { app, startServer };
