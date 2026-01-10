const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  email: {
    type: String,
    required: true,
    unique: true,
  },
  password: {
    type: String,
    required: true,
  },
  unlockCode: {
    type: String,
    required: true,
  },
  send_flag: {
    type: Boolean,
    default: false,
  },
  blocked_flag: {
    type: String,
    default: 0,
  },
  lastBlockedTime: {
    type: Date,
  },
  fcmToken: {
    type: String, default: null,
  }
});

module.exports = mongoose.model('User', userSchema);
