// routes/showRoutes.js
const express = require('express');
const router = express.Router();
const Show = require('../models/Show');

// 모든 공연 조회
router.get('/', async (req, res) => {
  try {
    const shows = await Show.find();
    res.json(shows);
  } catch (error) {
    res.status(500).json({ message: '공연 조회 실패', error });
  }
});

module.exports = router;

