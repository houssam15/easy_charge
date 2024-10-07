import 'package:recharge_by_scan/features/recharge_by_scan/domain/entities/recharge.dart';

abstract class RemoteRechargeAccountEvent{
  const RemoteRechargeAccountEvent();
}

class RemoteRechargeAccount extends RemoteRechargeAccountEvent{
  final RechargeEntity recharge;
  const RemoteRechargeAccount(this.recharge);
}

class RemoteRechargeAccountInitial extends RemoteRechargeAccountEvent{
  const RemoteRechargeAccountInitial();
}

class RemoteRechargeAccountListenSms extends RemoteRechargeAccountEvent{
  final bool activate;
  const RemoteRechargeAccountListenSms(this.activate);
}

