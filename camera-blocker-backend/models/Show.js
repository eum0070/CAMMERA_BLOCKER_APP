// models/Show.js
const mongoose = require('mongoose');

const showSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
  },
  start_time: {
    type: String, // 또는 Date 타입도 가능
    required: true,
  },
  end_time: {
    type: String, // 또는 Date 타입도 가능
    required: true,
  },
  date: {
    type: String, // 또는 Date 타입도 가능
    required: true,
  },
}, { timestamps: true });

module.exports = mongoose.model('Show', showSchema);
