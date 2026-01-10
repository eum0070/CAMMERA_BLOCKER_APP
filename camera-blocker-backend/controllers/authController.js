const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const User = require('../models/User');
require('dotenv').config();

exports.signup = async (req, res) => {
  const { email, password } = req.body;

  try {
    const exists = await User.findOne({ email });
    if (exists) return res.status(400).json({ message: '이미 등록된 이메일입니다.' });

    const hashedPassword = await bcrypt.hash(password, 10);
    const unlockCode = generateUnlockCode(); // 차단 해제 코드 생성
    const blocked_flag = 0;
    const send_flag = 0;

    const user = new User({
      email,
      password: hashedPassword,
      unlockCode,
      send_flag,
      blocked_flag,
    });

    await user.save();

    return res.status(201).json({ message: '회원가입 성공', unlockCode });
  } catch (err) {
    console.error(err);
    return res.status(500).json({ message: '서버 에러' });
  }
};

exports.login = async (req, res) => {
  const { email, password } = req.body;

  try {
    const user = await User.findOne({ email });
    if (!user) return res.status(400).json({ message: '이메일 또는 비밀번호가 잘못되었습니다.' });

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) return res.status(400).json({ message: '이메일 또는 비밀번호가 잘못되었습니다.' });

    if (user.blocked_flag != 0) return res.status(400).json({ message: '사용 불가 사용자 입니다.' });

    const token = jwt.sign({ userId: user._id }, process.env.JWT_SECRET, { expiresIn: '2h' });

    return res.status(200).json({
      message: '로그인 성공',
      token,
      user: {
        email: user.email,
        unlockCode: user.unlockCode,
        blocked_flag: user.blocked_flag,
      },
    });
  } catch (err) {
    console.error(err);
    return res.status(500).json({ message: '서버 에러' });
  }
};

function generateUnlockCode() {
  return Math.random().toString(36).substring(2, 10); // 8자리 임의 문자열
}
