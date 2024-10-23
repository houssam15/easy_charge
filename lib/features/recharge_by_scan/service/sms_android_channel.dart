import 'package:flutter/services.dart';

class SmsAndroidChannel {
  static const platform = MethodChannel('com.example/sms');
  Future<void> sendSms(String phone, String smsContent, int simSlot) async {
    try {
      await platform.invokeMethod('sendSms', {
        'phone': phone,
        'smsContent': smsContent,
        'simSlot': simSlot,
      });
    } on PlatformException catch (e) {
      print("Failed to send SMS: '${e.message}'.");
    }
  }
}