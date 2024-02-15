const request = require("supertest");
const { app, startServer } = require("./server");
const sequelize = require("./models");

describe("Server End Point", () => {
  it("should return 405 method not allowed for PUT request", async () => {
    const response = await request(app).put("/healthz");
    expect(response.status).toBe(405);
  });

  it("should return 405 method not allowed for DELETE request", async () => {
    const response = await request(app).delete("/healthz");
    expect(response.status).toBe(405);
  });

  it("should return 405 method not allowed for PATCH request", async () => {
    const response = await request(app).patch("/healthz");
    expect(response.status).toBe(405);
  });
  it("should return 405 method not allowed for POST request", async () => {
    const response = await request(app).post("/healthz");
    expect(response.status).toBe(405);
  });
});
