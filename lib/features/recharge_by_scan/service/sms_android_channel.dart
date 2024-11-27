import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:recharge_by_scan/core/resources/data_state.dart';

class SmsAndroidChannel {
  static const platform = MethodChannel('com.features.recharge_by_scan/sms');
  Future<DataState> sendSms(String phone, String smsContent, int? simSlot) async {
    try {
      String x = await platform.invokeMethod('sendSms', {
        'phone': phone,
        'smsContent': smsContent,
        'simSlot': simSlot
      });
      return  x=="OK"?const DataSuccess(null) : const DataFailed(null);
    }catch(err){
      if(kDebugMode) print(err);
      return const DataFailed(null);
    }
  }
}