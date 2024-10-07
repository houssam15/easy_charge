import 'dart:async';
import 'dart:io';

import 'package:recharge_by_scan/core/resources/data_state.dart';
import 'package:recharge_by_scan/features/recharge_by_scan/data/data_sources/remote/recharge_api_service.dart';
import 'package:recharge_by_scan/features/recharge_by_scan/data/models/sim_card.dart';
import 'package:recharge_by_scan/features/recharge_by_scan/data/models/sms.dart';
import 'package:recharge_by_scan/features/recharge_by_scan/domain/entities/recharge.dart';
import 'package:recharge_by_scan/features/recharge_by_scan/domain/entities/sim_card.dart';
import 'package:recharge_by_scan/features/recharge_by_scan/domain/repository/recharge_repository.dart';
import "package:dio/dio.dart";
import 'package:recharge_by_scan/features/recharge_by_scan/data/models/recharge.dart';
import 'package:recharge_by_scan/features/recharge_by_scan/service/sms.dart';


class RechargeRepositoryImpl implements RechargeRepository{
  final SmsService _smsService;

  RechargeRepositoryImpl(this._smsService);

  @override
  Future<DataState> rechargeAccount(RechargeEntity re) async{
    try{
      RechargeModel rm = RechargeModel.fromEntity(re);
      DataState<String,String> dataState =await _smsService.send(simSlot: rm.simCard.slotNumber,message: rm.getMessage(), number: SimCardModel.fromEntity(rm.simCard).getRechargeNumber());
      if(dataState is DataFailed) return DataFailed(dataState.error);
      return const DataSuccess("Recharge sent , check your messages !");
    } catch(err){
      return DataFailed(err.toString());
    }
  }

  @override
  Future<DataState<List<SimCardEntity>,String>> getUserAccounts() async{
    try{
      DataState<List<SimCardModel>,String> dataState =await _smsService.getSimCards();
      if(dataState is DataFailed) return DataFailed(dataState.error);
      return DataSuccess(SimCardModel.toEntities(dataState.data??[]));
    }catch(err){
      return DataFailed(err.toString());
    }
  }

  @override
  Future<DataState<Stream<SmsModel>?,String>> listenIncomingSms({required bool activate})async{
    try{
      final StreamController<SmsModel> smsStreamController = StreamController();
      DataState<String,String>? dataState;
      if(activate==true) {
        dataState = await _smsService.listenIncomingSms()?.startListening(smsStreamController:smsStreamController);
      } else {
        dataState = await _smsService.listenIncomingSms()?.stopListening();
      }
      return dataState==null || dataState is DataFailed?DataFailed(dataState?.error??"Unknown Error"): DataSuccess(!activate?null:smsStreamController.stream);
    }catch(err){
      return DataFailed(err.toString());
    }
  }

}