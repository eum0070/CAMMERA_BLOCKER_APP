import 'package:flutter/services.dart';

class DeviceAdminService {
  static const platform = MethodChannel('camera_admin');

  static Future<bool> hasAdminPermission() async {
    try {
      final bool result = await platform.invokeMethod('checkAndRequestAdmin');
      print("🟢 MethodChannel 호출 성공: $result");
      return result;
    } catch (e, stack) {
      print("🔴 MethodChannel 오류 발생: $e");
      print(stack);
      return false;
    }
  }

  static Future<void> requestAdminPermission() async {
    // 통합 처리로 이 함수는 호출 안 해도 무방함
    await hasAdminPermission(); // 같은 메서드로 처리됨
  }
}
