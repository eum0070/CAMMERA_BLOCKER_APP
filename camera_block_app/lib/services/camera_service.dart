// lib/services/camera_service.dart
import 'package:flutter/services.dart';
import 'package:workmanager/workmanager.dart';

const MethodChannel _channel = MethodChannel('camera_admin');

class CameraService {
  static Future<void> blockCameraAndStartCheck() async {
    final result = await _channel.invokeMethod('blockCamera');
    if (result == "success") {
      await Workmanager().registerPeriodicTask(
        "camera_check_task",
        "cameraCheckTask",
        frequency: Duration(minutes: 15),
      );
    }
  }

  static Future<void> unblockCameraAndStopCheck() async {
    final result = await _channel.invokeMethod('unblockCamera');
    if (result == "success") {
      await Workmanager().cancelByUniqueName("camera_check_task");
    }
  }
}
