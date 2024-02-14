const supertest = require("supertest");
const { app, startServer } = require("./server");
const users = require("./models/Users");
const assert = require("assert");
const sequelize = require("./models");

// let server;

before(async () => {
  sequelize.sync();
});

describe("USER API", () => {
  it("should create a new user", async () => {
    const responsePromise = await supertest(app).post("/v1/user").send({
      first_name: "John",
      last_name: "Doe",
      username: "johndoe@example.com",
      password: "password123",
    });
    const response = await responsePromise;
    assert.strictEqual(response.status, 201);

    const createdUser = await users.findOne({
      where: { email: "johndoe@example.com" },
    });

    assert.ok(createdUser);
    assert.strictEqual(createdUser.firstname, "John");
    assert.strictEqual(createdUser.lastname, "Doe");
    assert.strictEqual(createdUser.email, "johndoe@example.com");
  });

  it("should return 400 if email is not in correct format", async () => {
    const response = await supertest(app).post("/v1/user").send({
      first_name: "John",
      last_name: "Doe",
      username: "invalidemail",
      password: "password123",
    });

    assert.strictEqual(response.status, 400);
  });

  // it("should return 400 if user already exists", async () => {
  //   await users.create({
  //     firstname: "John",
  //     lastname: "Doe",
  //     email: "john@example.com",
  //     password: "password123",
  //   });

  //   const response = await supertest(app).post("/v1/user").send({
  //     first_name: "John",
  //     last_name: "Doe",
  //     username: "john@example.com",
  //     password: "password123",
  //   });

  //   assert.strictEqual(response.status, 400);
  // });

  it("should return error if the email is invalid", async () => {
    const response = await supertest(app).post("/v1/user").send({
      first_name: "Jane",
      last_name: "Doe",
      username: "invalidemail",
      password: "password123",
    });

    assert.strictEqual(response.status, 400);
  });

  it("should update user information", async () => {
    const response = await supertest(app)
      .put("/v1/user/self")
      .set(
        "Authorization",
        `Basic ${Buffer.from("johndoe@example.com:password123").toString(
          "base64"
        )}`
      )
      .send({
        first_name: "Updated john",
        last_name: "Updated doe",
        password: "abhaydeshpandeupdated",
      });

    assert.strictEqual(response.status, 200);

    const updatedUser = await users.findOne({
      where: { email: "johndoe@example.com" },
    });

    assert.strictEqual(updatedUser.firstname, "Updated john");
    assert.strictEqual(updatedUser.lastname, "Updated doe");
  });

  // it("should return 400 for attempting to update other user's information", async () => {
  //   await users.create({
  //     firstname: "Jane",
  //     lastname: "Doe",
  //     email: "jane@example.com",
  //     password: "password456",
  //   });

  //   const response = await supertest(app)
  //     .put("/v1/user/self")
  //     .set(
  //       "Authorization",
  //       `Basic ${Buffer.from("jane@example.com:dasdasdasdasd").toString(
  //         "base64"
  //       )}`
  //     )
  //     .send({
  //       first_name: "Updated Jane",
  //       last_name: "Updated Doe",
  //       password: "newpassword456",
  //     });

  //   assert.strictEqual(response.status, 400);
  // });

  // it("should return 401 if authorization header is missing", async () => {
  //   const response = await supertest(app).put("/v1/user/self").send({
  //     first_name: "Updated John",
  //     last_name: "Updated Doe",
  //     password: "newpassword123",
  //   });

  //   assert.strictEqual(response.status, 401);
  // });

  // it("should return 400 if email is included in the request body", async () => {
  //   const response = await supertest(app)
  //     .put("/v1/user/self")
  //     .set(
  //       "Authorization",
  //       `Basic ${Buffer.from("john@example.com:password123").toString(
  //         "base64"
  //       )}`
  //     )
  //     .send({
  //       first_name: "Updated John",
  //       last_name: "Updated Doe",
  //       email: "updated@example.com",
  //       password: "newpassword123",
  //     });

  //   assert.strictEqual(response.status, 400);
  // });

  // after(() => {
  //   server.close();
  // });
});
