import 'package:recharge_by_scan/features/recharge_by_scan/domain/entities/sms.dart';

class SmsModel extends SmsEntity{
  SmsModel({
    required super.sender,
    required super.body,
    required super.receivedAt,
  });
}