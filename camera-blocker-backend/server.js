const express = require('express');
const cors = require('cors');
const connectDB = require('./config/db');
const User = require('./models/User'); //user db 불러오기
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

// DB 연결
connectDB();

// Middleware
app.use(cors());
app.use(express.json());

// Routes
app.use('/api/auth', require('./routes/authRoutes'));
app.use('/api/shows', require('./routes/showRoutes'));


app.listen(PORT,'0.0.0.0', () => {
  console.log(`🚀 서버 실행 중: http://0.0.0.0:${PORT}`);
});

app.use((req, res, next) => {
  console.log(`${req.method} ${req.url}`);
  next();
}); //백엔드에서 로그 찍기

// ✅ 이메일로 사용자 조회
app.post('/verify-unlock', async (req, res) => {
  const { email, code } = req.body;

  const user = await User.findOne({ email });

  if (!user) return res.status(404).send({ message: 'User not found' });

  if (user.unlockCode === code) {
    return res.send({ success: true });
  } else {
    return res.status(403).send({ message: '해제 문자열이 틀립니다.' });
  }
});
