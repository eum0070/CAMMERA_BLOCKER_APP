//import 'package:camera_block_app/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/agreement_screen.dart';
import 'screens/unlockcamera_screen.dart';
import 'screens/show_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'background_task.dart';

Future<void> requestNotificationPermission() async {
  NotificationSettings settings = await FirebaseMessaging.instance
      .requestPermission();

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('🔔 알림 권한 허용됨');
  } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
    print('❌ 알림 권한 거부됨');
  } else {
    print('⚠️ 알림 권한 상태: ${settings.authorizationStatus}');
  }
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Workmanager().initialize(
    callbackDispatcher, // 👈 이 부분 중요!
    isInDebugMode: true, // 디버깅할 때 true로 두세요
  );

  await Workmanager().registerPeriodicTask(
    "camera_check_task", // 고유한 ID
    "cameraCheckTask", // 작업 이름
    frequency: Duration(minutes: 15), // Android는 최소 15분
  );

  runApp(CameraBlockApp());
}

class CameraBlockApp extends StatelessWidget {
  const CameraBlockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camera Block App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/home': (_) => HomeScreen(),
        // 공연 선택 라우트 // 임시
        '/agreement': (context) => AgreementScreen(),
        '/unlockcamera': (context) => UnlockCameraScreen(),
        '/show': (_) => ShowScreen(),
      },
    );
  }
}
