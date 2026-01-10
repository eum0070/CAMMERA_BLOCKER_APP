import 'package:flutter/material.dart';

class AgreementScreen extends StatefulWidget {
  const AgreementScreen({super.key});

  @override
  State<AgreementScreen> createState() => _AgreementScreenState();
}

class _AgreementScreenState extends State<AgreementScreen> {
  // 권한 설정 함수 (예: 권한 요청 로직 직접 구현 필요)

  // 권한 상태 확인 함수
  Future<bool> _getStatus() async {
    // 실제 권한 확인 로직 필요
    return true; // 테스트용
  }

  void _agreeAndContinue(BuildContext context) {
    _getStatus().then((granted) {
      if (granted) {
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('필수 권한을 허용해야 계속 진행할 수 있습니다.')));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: Stack(
        children: <Widget>[
          // 이미지 배경
          Positioned.fill(
            top: 20,
            bottom: 40,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Image.asset(
                'image/permission.png',
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),

          // 하단 버튼
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: double.infinity,
              height: 50.0,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff212121),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                    side: const BorderSide(color: Color(0xff212121)),
                  ),
                ),
                onPressed: () => _agreeAndContinue(context),
                child: const Text(
                  "권한 확인",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
