const express = require('express');

const Task = require('../models/task');

const router = express.Router();

// Rate limiting middleware
const rateLimit = require('express-rate-limit');
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // limit each IP to 100 requests per windowMs
});

// Apply the rate limiter to all routes in this router
router.use(limiter);
router.get('/', (req, res) => {
  Task.find({})
    .then(tasks => res.json(tasks))
    .catch(err => res.status(500).json({ error: err }));
});

router.post('/add', (req, res) => {
  const { title } = req.body;
  const newTask = new Task({ title });

  newTask.save()
    .then(task => res.json(task))
    .catch(err => res.json(500, err));
});

router.delete('/delete/:id', (req, res) => {
  const id = req.params.id;

  Task.findByIdAndDelete(id)
    .then(task => res.json(task))
    .catch(err => res.json(500, err));
});

router.post('/update/:id', (req, res) => {
  const { done } = req.body;
  Task.findByIdAndUpdate(req.params.id, { done })
    .then(task => res.json(task))
    .catch(err => res.json(500, err));
});

module.exports = router;
