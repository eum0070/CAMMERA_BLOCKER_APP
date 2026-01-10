import 'package:camera_block_app/models/show.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workmanager/workmanager.dart';

class SelectShowScreen extends StatelessWidget {
  const SelectShowScreen({super.key, required this.show});

  final Show show;

  static const platform = MethodChannel('camera_admin');

  Future<void> _blockCamera(BuildContext context) async {
    try {
      final result = await platform.invokeMethod('blockCamera');
      if (result == 'success') {
        // 카메라 차단 성공 시 WorkManager에 주기 작업 등록
        await Workmanager().registerPeriodicTask(
          "camera_check_task",
          "cameraCheckTask",
          frequency: const Duration(minutes: 15),
        );
      } else if (result == 'not_admin') {
        _showError(context, 'Device Admin 권한이 없습니다.');
      } else {
        _showError(context, '카메라 차단에 실패했습니다.');
      }
    } on PlatformException catch (e) {
      _showError(context, '오류 발생: ${e.message}');
    }
  }

  void _showError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('오류'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('확인'),
          ),
        ],
      ),
    );
  }

  void _confirmCameraBlock(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("카메라 차단"),
        content: const Text("카메라를 차단하시겠습니까?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text("아니오"),
          ),
          TextButton(
            onPressed: () {
              _blockCamera(context);
              Navigator.pop(context, true);
            },
            child: const Text("네"),
          ),
        ],
      ),
    );

    if (result == true) {
      Navigator.pop(context, true); // 홈화면에 차단 상태 전달
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text("공연 정보"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              show.name,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  show.date,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  '${show.startTime} ~ ${show.endTime}',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Center(
              child: Text(
                '본 공연장에 입장하기 위해서는\n카메라 차단이 필요합니다.\n카메라를 차단해주세요.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _confirmCameraBlock(context),
                icon: const Icon(Icons.block),
                label: const Text("카메라 차단하기"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
