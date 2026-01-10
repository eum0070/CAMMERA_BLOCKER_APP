import 'package:camera_block_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:workmanager/workmanager.dart';

class UnlockCameraScreen extends StatefulWidget {
  const UnlockCameraScreen({super.key});

  @override
  State<UnlockCameraScreen> createState() => _UnlockCameraScreenState();
}

class _UnlockCameraScreenState extends State<UnlockCameraScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final MethodChannel _channel = const MethodChannel('camera_admin');
  String? _message;

  Future<void> _verifyAndUnblock() async {
    final email = _emailController.text.trim();
    final code = _codeController.text.trim();

    if (email.isEmpty || code.isEmpty) {
      setState(() => _message = '이메일과 코드를 모두 입력해주세요.');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://172.31.77.182:3000/verify-unlock'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'code': code}),
      );

      if (response.statusCode == 200) {
        final result = await _channel.invokeMethod('unblockCamera');
        if (result == 'success') {
          await Workmanager().cancelByUniqueName("camera_check_task");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => HomeScreen()),
          );
        } else {
          setState(() => _message = '관리자 권한이 필요합니다.');
        }
      } else {
        final error = json.decode(response.body);
        setState(() => _message = error['message']);
      }
    } catch (e) {
      setState(() => _message = '서버 요청 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text('카메라 차단 해제'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '카메라 해제 문자열 입력',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '이메일과 해제 코드를 입력하여 카메라 차단을 해제하세요.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 30),

              // 이메일 입력
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: '이메일',
                  prefixIcon: const Icon(Icons.email),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 코드 입력
              TextField(
                controller: _codeController,
                decoration: InputDecoration(
                  labelText: '해제 코드',
                  prefixIcon: const Icon(Icons.vpn_key),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 버튼
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _verifyAndUnblock,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '카메라 차단 해제',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              // 메시지
              if (_message != null)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Center(
                    child: Text(
                      _message!,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
