const mysql = require('mysql2');

const db = mysql.createConnection({
  host: process.env.DB_HOST || 'localhost',
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || '',
  database: process.env.DB_NAME || 'taskmate'
});

db.connect((err) => {
  if (err) {
    console.error('DB connection error:', err.message);
  } else {
    console.log('Connected to MySQL DB');
  }
});

module.exports = db;
