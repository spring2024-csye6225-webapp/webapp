const request = require("supertest");
const app = require("./server");

describe("Server End Point", () => {
  it("should check for the health status 200", async () => {
    const response = await request(app).get("/healthz");
    expect(response.status).toBe(200);
  });

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

  it("it should return 405 if body is passed along with the get request", async () => {
    const response = await request(app).get("/healthz").send({ key: "value" });
    expect(response.status).toBe(405);
  });
});
