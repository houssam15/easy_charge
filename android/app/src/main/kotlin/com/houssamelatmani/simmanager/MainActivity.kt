package com.houssamelatmani.simmanager

import android.annotation.TargetApi
import android.content.Context
import android.os.Build
import android.telephony.SmsManager
import android.telephony.SubscriptionManager
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity:

    FlutterActivity() {
    private val CHANNEL = "com.features.recharge_by_scan/sms"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            if (call.method == "sendSms") {
                val phone = call.argument<String>("phone")
                val smsContent = call.argument<String>("smsContent")
                val simSlot = call.argument<Int>("simSlot")
                Log.d("SMS_DEBUG", "Phone: $phone, SMS: $smsContent, SIM Slot: $simSlot")
                if (phone != null && smsContent != null && simSlot != null) {
                    // Add your SMS sending logic here
                    val response = sendSms(this@MainActivity,phone, smsContent, simSlot)
                    result.success(response)
                } else {
                    result.error("INVALID_ARGUMENTS", "Missing parameters", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    @TargetApi(Build.VERSION_CODES.LOLLIPOP_MR1)
    private fun sendSms(context: Context, phone: String, smsContent: String, simSlot: Int): String {
        try {
            val subscriptionManager = context.getSystemService(Context.TELEPHONY_SUBSCRIPTION_SERVICE) as SubscriptionManager
            val subscriptionInfoList = subscriptionManager.activeSubscriptionInfoList
            if (simSlot < 0 || simSlot >= subscriptionInfoList.size) {
                return "Invalid SIM slot: $simSlot"
            }
            val subscriptionId = subscriptionInfoList[simSlot].subscriptionId
            val smsManager = SmsManager.getSmsManagerForSubscriptionId(subscriptionId)
            smsManager.sendTextMessage(phone, null, smsContent, null, null)
            return "OK"
        } catch (e: Exception) {
            return "KO"
        }
    }
}


