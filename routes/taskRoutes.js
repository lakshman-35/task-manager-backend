const express = require('express');
const router = express.Router();
const db = require('../db');

// CREATE
router.post('/', (req, res) => {
  const { title, description, status, priority, dueDate } = req.body;
  const userId = req.userId;
  const sql = 'INSERT INTO tasks (title, description, status, priority, due_date, user_id) VALUES (?, ?, ?, ?, ?, ?)';
  db.query(sql, [title, description, status, priority, dueDate, userId], (err, result) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json({ id: result.insertId, ...req.body, user_id: userId });
  });
});

// READ - Get tasks for the authenticated user
router.get('/', (req, res) => {
  const userId = req.userId;
  db.query('SELECT * FROM tasks WHERE user_id = ? ORDER BY created_at DESC', [userId], (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
});

// UPDATE
router.put('/:id', (req, res) => {
  const { title, description, status, priority, dueDate } = req.body;
  const userId = req.userId;
  const taskId = req.params.id;
  const checkOwnershipSQL = 'SELECT * FROM tasks WHERE id = ? AND user_id = ?';
  db.query(checkOwnershipSQL, [taskId, userId], (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    if (results.length === 0) {
      return res.status(403).json({ message: 'Access denied' });
    }
    const sql = 'UPDATE tasks SET title=?, description=?, status=?, priority=?, due_date=? WHERE id=? AND user_id=?';
    db.query(sql, [title, description, status, priority, dueDate, taskId, userId], (err) => {
      if (err) return res.status(500).json({ error: err.message });
      res.json({ message: 'Task updated' });
    });
  });
});

// DELETE
router.delete('/:id', (req, res) => {
  const userId = req.userId;
  const taskId = req.params.id;
  const checkOwnershipSQL = 'SELECT * FROM tasks WHERE id = ? AND user_id = ?';
  db.query(checkOwnershipSQL, [taskId, userId], (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    if (results.length === 0) {
      return res.status(403).json({ message: 'Access denied' });
    }
    db.query('DELETE FROM tasks WHERE id = ? AND user_id = ?', [taskId, userId], (err) => {
      if (err) return res.status(500).json({ error: err.message });
      res.json({ message: 'Task deleted' });
    });
  });
});

module.exports = router;
