import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://172.31.77.182:3000/api/auth';

  static Future<dynamic> signup({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      return jsonDecode(response.body)['message'] ?? '회원가입 실패';
    }
  }

  static Future<dynamic> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      // 추후 secure storage에 토큰 저장 가능
      return true;
    } else {
      return jsonDecode(response.body)['message'] ?? '로그인 실패';
    }
  }
}
