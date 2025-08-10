import express from "express";
import pg from "pg";

const app = express();
const port = process.env.PORT || 3000;
const pool = new pg.Pool({ connectionString: process.env.DATABASE_URL });

app.get("/api/health", (req, res) => {
  res.json({ ok: true });
});

app.get("/api/db-test", async (req, res) => {
  try {
    await pool.query("select 1");
    res.json({ db: "ok" });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

app.listen(port, () => {
  console.log(`backend listening on ${port}`);
});
