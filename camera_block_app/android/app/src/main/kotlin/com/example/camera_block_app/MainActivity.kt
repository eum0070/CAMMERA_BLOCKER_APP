package com.example.camera_block_app

import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "camera_admin"
    private val REQUEST_CODE = 1001
    private lateinit var policyManager: DevicePolicyManager
    private lateinit var adminReceiver: ComponentName
    private var methodResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        policyManager = getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
        adminReceiver = ComponentName(this, CameraAdminReceiver::class.java)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "checkAndRequestAdmin" -> {
                    if (!policyManager.isAdminActive(adminReceiver)) {
                        methodResult = result
                        val intent = Intent(DevicePolicyManager.ACTION_ADD_DEVICE_ADMIN)
                        intent.putExtra(DevicePolicyManager.EXTRA_DEVICE_ADMIN, adminReceiver)
                        intent.putExtra(DevicePolicyManager.EXTRA_ADD_EXPLANATION, "카메라 차단을 위해 권한이 필요합니다.")
                        startActivityForResult(intent, REQUEST_CODE)
                    } else {
                        result.success(true)
                    }
                }
                "blockCamera" -> {
                    if (policyManager.isAdminActive(adminReceiver)) {
                        policyManager.setCameraDisabled(adminReceiver, true)
                        result.success("success")
                    } else {
                        result.success("not_admin")
                    }
                }

                "unblockCamera" -> {
                    if (policyManager.isAdminActive(adminReceiver)) {
                        policyManager.setCameraDisabled(adminReceiver, false)
                        result.success("success")
                    } else {
                        result.success("not_admin")
                    }
                }

                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == REQUEST_CODE) {
            // 권한 수락 여부 확인
            val granted = policyManager.isAdminActive(adminReceiver)
            methodResult?.success(granted)
            methodResult = null
        }
    }
}
