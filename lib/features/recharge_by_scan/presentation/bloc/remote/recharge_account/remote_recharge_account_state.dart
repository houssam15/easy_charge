import 'package:equatable/equatable.dart';
import "package:dio/dio.dart";
import 'package:recharge_by_scan/features/recharge_by_scan/domain/entities/sim_card.dart';
import 'package:recharge_by_scan/features/recharge_by_scan/domain/entities/sms.dart';

abstract class RemoteRechargeAccountState<T,E> extends Equatable{
  final T? data;
  final E? error;

  const RemoteRechargeAccountState({this.data,this.error});

  @override
  List<Object?> get props => [data,error];
}


class RemoteRechargeAccountInitialState extends RemoteRechargeAccountState {
  const RemoteRechargeAccountInitialState(dynamic data):super(data: data);
}
class RemoteRechargeAccountLoading extends RemoteRechargeAccountState{
  const RemoteRechargeAccountLoading();
}

class RemoteRechargeAccountDone extends RemoteRechargeAccountState{
  const RemoteRechargeAccountDone(dynamic data):super(data: data);
}

class RemoteRechargeAccountError extends RemoteRechargeAccountState{
  const RemoteRechargeAccountError(String? error):super(error: error);
}

class RemoteRechargeAccountListeningStatus extends RemoteRechargeAccountState<bool,String>{

  const RemoteRechargeAccountListeningStatus({required bool data,String? error}):super(data: data,error: error);
}
class RemoteRechargeAccountNewSmsReceivedStatus extends RemoteRechargeAccountState<SmsEntity,String>{
  const RemoteRechargeAccountNewSmsReceivedStatus({required SmsEntity sms}):super(data: sms);
}
