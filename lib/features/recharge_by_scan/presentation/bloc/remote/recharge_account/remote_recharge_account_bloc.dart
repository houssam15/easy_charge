import 'package:flutter/foundation.dart';
import 'package:recharge_by_scan/core/resources/data_state.dart';
import 'package:recharge_by_scan/features/recharge_by_scan/domain/entities/sms.dart';
import 'package:recharge_by_scan/features/recharge_by_scan/domain/usecases/get_user_accounts.dart';
import 'package:recharge_by_scan/features/recharge_by_scan/domain/usecases/listen_incoming_sms.dart';
import 'package:recharge_by_scan/features/recharge_by_scan/domain/usecases/recharge_account.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recharge_by_scan/features/recharge_by_scan/presentation/bloc/remote/recharge_account/remote_recharge_account_event.dart';
import 'package:recharge_by_scan/features/recharge_by_scan/presentation/bloc/remote/recharge_account/remote_recharge_account_state.dart';

class RemoteRechargeAccountBloc extends Bloc<RemoteRechargeAccountEvent,RemoteRechargeAccountState>{

  final RechargeAccountUseCase _rechargeAccountUseCase;
  final GetUserAccountsUseCase _getUserAccountsUseCase;
  final ListenIncomingSmsUseCase _listenIncomingSmsUseCase;

  RemoteRechargeAccountBloc(this._rechargeAccountUseCase,this._getUserAccountsUseCase,this._listenIncomingSmsUseCase):super(const RemoteRechargeAccountLoading()){
   on <RemoteRechargeAccount> (onRechargeAccount);
   on<RemoteRechargeAccountInitial> (onRechargeAccountInitial);
   on<RemoteRechargeAccountListenSms> (onRemoteRechargeAccountListenSms);
  }

  void onRechargeAccount(RemoteRechargeAccount event,Emitter<RemoteRechargeAccountState> emit) async{
      final dataState = await _rechargeAccountUseCase(params: event.recharge);
      if(dataState is DataSuccess && dataState.data!.isNotEmpty){
        emit(RemoteRechargeAccountDone(dataState.data));
      }
      if(dataState is DataFailed){
        print(dataState.error?.message);
        emit(
          RemoteRechargeAccountError(dataState.error!)
        );
      }
  }

  void onRechargeAccountInitial(RemoteRechargeAccountInitial event,Emitter<RemoteRechargeAccountState> emit) async{
    final dataState = await _getUserAccountsUseCase();
    if(dataState is DataSuccess) emit(RemoteRechargeAccountInitialState(dataState.data));
    if(dataState is DataFailed){
      if(kDebugMode) print(dataState.error);
      emit(RemoteRechargeAccountError(dataState.error));
    }
  }

  void onRemoteRechargeAccountListenSms(RemoteRechargeAccountListenSms event,Emitter<RemoteRechargeAccountState> emit) async {
    final dataState = await  _listenIncomingSmsUseCase(params: event.activate);
    emit(
        RemoteRechargeAccountListeningStatus(
            data:dataState is DataSuccess && dataState.data!=null,
            error: dataState.error
        )
    );

    if(dataState is DataSuccess && dataState.data !=null) {
      await emit.forEach<SmsEntity>(
          dataState.data!,
          onData: (SmsEntity sms){
             return RemoteRechargeAccountNewSmsReceivedStatus(sms: sms);
          }
    );
    }

  }
}