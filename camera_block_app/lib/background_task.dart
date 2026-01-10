import 'package:workmanager/workmanager.dart';
import 'package:flutter/services.dart';

const MethodChannel _channel = MethodChannel('camera_admin');

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      final bool isCameraBlocked = await _channel.invokeMethod(
        'checkCameraBlocked',
      );
      print("카메라 차단 상태: $isCameraBlocked");

      // TODO: 알림 보내기 등 추가 로직 가능
    } catch (e) {
      print("카메라 상태 확인 실패: $e");
    }

    return Future.value(true); // 작업 완료 표시
  });
}
