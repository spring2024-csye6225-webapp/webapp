const supertest = require("supertest");
const { app } = require("../server.js");
const users = require("../models/Users.js");
const assert = require("assert");
const sequelize = require("../models/index.js");
const mocha = require("mocha");
const { before } = mocha;

before(async () => {
  await sequelize.sync();
});

describe("test healthz api", () => {
  it("should return 405 method not allowed for PUT request", async () => {
    const response = await supertest(app).put("/healthz");
    assert.strictEqual(response.status, 405);
  });

  it("should return 405 method not allowed for DELETE request", async () => {
    const response = await supertest(app).delete("/healthz");
    assert.strictEqual(response.status, 405);
  });

  it("should return 405 method not allowed for PATCH request", async () => {
    const response = await supertest(app).patch("/healthz");
    assert.strictEqual(response.status, 405);
  });

  it("should return 405 method not allowed for POST request", async () => {
    const response = await supertest(app).post("/healthz");
    assert.strictEqual(response.status, 405);
  });
});

if (process.env.NODE_ENV !== "dev") {
  describe("USER API", function () {
    it("should create a new user", async function () {
      const responsePromise = await supertest(app).post("/v1/user").send({
        first_name: "John",
        last_name: "Doe",
        username: "johndoe@example.com",
        password: "password123",
        userVerified: false,
      });

      const response = await responsePromise;
      assert.strictEqual(response.status, 201);

      const createdUser = await users.findOne({
        where: { email: "johndoe@example.com" },
      });
      console.log("the created user", createdUser);
      assert.ok(createdUser);
      assert.strictEqual(createdUser.firstname, "John");
      assert.strictEqual(createdUser.lastname, "Doe");
      assert.strictEqual(createdUser.email, "johndoe@example.com");
    });

    if (process.env.NODE_ENV !== "dev") {
      it("should update user information", async () => {
        // To test the update functionality, we will simulate user verification here
        const user = await users.create({
          firstname: "John",
          lastname: "Doe",
          email: "johndoe@example.com",
          password: "password123",
        });

        // Simulate user verification by updating the userVerified field to true
        await user.update({ userVerified: true });

        // Update user information
        const response = await supertest(app)
          .put("/v1/user/self")
          .set(
            "Authorization",
            `Basic ${Buffer.from("johndoe@example.com:password123").toString(
              "base64"
            )}`
          )
          .send({
            first_name: "Updated John",
            last_name: "Updated Doe",
            password: "updatedpassword123",
          });

        assert.strictEqual(response.status, 200);

        // Check updated user information
        const updatedUser = await users.findOne({
          where: { email: "johndoe@example.com" },
        });

        assert.strictEqual(updatedUser.firstname, "Updated John");
        assert.strictEqual(updatedUser.lastname, "Updated Doe");
        assert.strictEqual(updatedUser.userVerified, true); // User should be verified after update
      });
    }
  });
}
