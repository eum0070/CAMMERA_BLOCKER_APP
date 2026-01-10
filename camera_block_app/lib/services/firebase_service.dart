import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FirebaseService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  static Future<void> initialize() async {
    await Firebase.initializeApp();
    await _firebaseMessaging.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        print('📩 FCM 수신: ${message.notification!.title}');
      }
    });
  }

  static Future<String?> getFcmToken() async {
    return await _firebaseMessaging.getToken();
  }

  static Future<void> sendTokenToServer({
    required String userId,
    required String showId,
  }) async {
    final token = await _firebaseMessaging.getToken();
    if (token == null) return;

    const serverUrl = 'http://172.31.77.182:3000/api/schedule-notification';

    final response = await http.post(
      Uri.parse(serverUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': userId, 'showId': showId, 'fcmToken': token}),
    );

    if (response.statusCode == 200) {
      print('✅ FCM 토큰 서버 전송 성공');
    } else {
      print('❌ 서버 오류: ${response.body}');
    }
  }
}
