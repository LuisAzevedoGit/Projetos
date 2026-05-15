const mysql = require("mysql2");

let connection;

function connectWithRetry() {
  connection = mysql.createConnection({
    host: "db",
    user: "root",
    password: "example",
    database: "appdb"
  });

  connection.connect(err => {
    if (err) {
      console.log("DB not ready, retrying in 3s...");
      setTimeout(connectWithRetry, 3000);
    } else {
      console.log("Connected to MySQL");
    }
  });
}

connectWithRetry();

module.exports = {
  query: (...args) => connection.query(...args)
};