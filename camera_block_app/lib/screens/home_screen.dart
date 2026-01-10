import 'package:flutter/material.dart';
import 'package:camera_block_app/screens/show_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isCameraBlocked = false;

  void _navigateToShow() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => ShowScreen()),
    );

    if (result == true) {
      setState(() {
        isCameraBlocked = true;
      });
    } else if (result == false) {
      setState(() {
        isCameraBlocked = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cameraIcon = isCameraBlocked ? Icons.videocam_off : Icons.videocam;
    final cameraText = isCameraBlocked ? "카메라가 차단되었습니다." : "카메라 차단이 해제되었습니다.";

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            // 작은 화면에서도 스크롤 가능하도록
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "환영합니다 👋",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "원하는 기능을 선택하세요.",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 40),

                  Icon(cameraIcon, size: 100, color: Colors.blue),
                  const SizedBox(height: 16),
                  Text(
                    cameraText,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 30),

                  ElevatedButton.icon(
                    onPressed: _navigateToShow,
                    icon: const Icon(Icons.theaters),
                    label: const Text("공연 선택하러 가기"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),

                  if (isCameraBlocked) ...[
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/unlockcamera'),
                      icon: const Icon(Icons.lock_open),
                      label: const Text("카메라 해제하기"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
