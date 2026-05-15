const express = require("express");
const db = require("./db");

const app = express();
app.use(express.json());

// CREATE
app.post("/users", (req, res) => {
  const { name } = req.body;
  db.query("INSERT INTO users (name) VALUES (?)", [name]);
  res.send("User created");
});

// READ
app.get("/users", (req, res) => {
  db.query("SELECT * FROM users", (err, results) => {
    res.json(results);
  });
});

// DELETE
app.delete("/users/:id", (req, res) => {
  db.query("DELETE FROM users WHERE id = ?", [req.params.id]);
  res.send("User deleted");
});

app.listen(3000, () => {
  console.log("API running on port 3000");
});