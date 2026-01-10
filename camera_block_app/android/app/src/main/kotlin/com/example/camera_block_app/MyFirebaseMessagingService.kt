package com.example.camera_block_app

import android.util.Log
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage

class MyFirebaseMessagingService : FirebaseMessagingService() {

    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        Log.d("FCM", "메시지 수신됨: ${remoteMessage.notification?.title}, ${remoteMessage.notification?.body}")
        // 여기서 알림 팝업을 띄우거나, 특정 로직 실행 가능
    }

    override fun onNewToken(token: String) {
        super.onNewToken(token)
        Log.d("FCM", "새로운 FCM 토큰: $token")
        // 서버에 토큰 전송 등의 작업 가능
    }
}
