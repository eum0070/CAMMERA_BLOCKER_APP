const admin = require("firebase-admin");
const path = require("path");

// Firebase 서비스 계정 키 JSON 파일 (구글 Firebase 콘솔에서 다운로드)
const serviceAccount = require(path.join(__dirname, "firebase-key.json"));

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

module.exports = admin;
