import "dart:async";
import "package:background_sms/background_sms.dart" as MyBackgroundSms;
import "package:flutter/foundation.dart";
import "package:permission_handler/permission_handler.dart";
import "package:recharge_by_scan/core/resources/data_state.dart" as MyDataState;
import "package:recharge_by_scan/features/recharge_by_scan/data/models/sim_card.dart";
import "package:recharge_by_scan/features/recharge_by_scan/service/sms_android_channel.dart";
import "package:sim_card_info/sim_card_info.dart" as MySimCardInfo;
import "package:sim_card_info/sim_info.dart" as MySimInfo;
import 'package:readsms/readsms.dart' as MySmsReader;
import "../data/models/sms.dart";
import 'package:flutter_sms_plus/flutter_sms_plus.dart' as MyFlutterSmsPlus;

class SmsService{

    MySmsReader.Readsms? _smsReader;

    Future<PermissionStatus> grantPermissions() async{
        if(await Permission.sms.isDenied)  await Permission.sms.request();
        if(await Permission.phone.isDenied) await Permission.phone.request();
        if(await Permission.camera.isDenied) await Permission.camera.request();
        return await Permission.sms.isGranted && await Permission.phone.isGranted && await Permission.camera.isGranted? PermissionStatus.granted:PermissionStatus.denied;
    }

    Future<MyDataState.DataState<String,String>> send({required int? simSlot , required String? number , required String? message}) async{
        try{
          PermissionStatus status = await grantPermissions();
          if(status == PermissionStatus.denied) return const MyDataState.DataFailed("Can't grant permissions !");
          if(kDebugMode) print(await MyBackgroundSms.BackgroundSms.isSupportCustomSim);
          //MyBackgroundSms.SmsStatus sms = await MyBackgroundSms.BackgroundSms.sendMessage(simSlot: simSlot ,phoneNumber: number.toString(), message: message.toString());
          MyDataState.DataState sms = await SmsAndroidChannel().sendSms(number.toString(), message.toString(), simSlot);
          if(sms is MyDataState.DataFailed) return const MyDataState.DataFailed("Can't send message !");
          return const MyDataState.DataSuccess("Is sent");
        }catch(err){
          return MyDataState.DataFailed(err.toString());
        }
    }

    Future<MyDataState.DataState<List<SimCardModel>,String>> getSimCards() async{
        try{
          PermissionStatus status = await grantPermissions();
          if(status == PermissionStatus.denied) return const MyDataState.DataFailed("Can't grant permissions !");
          List<MySimInfo.SimInfo> simData = await MySimCardInfo.SimCardInfo().getSimInfo()??[];
          if(simData.isEmpty) return  MyDataState.DataSuccess([]);
          else {
        return MyDataState.DataSuccess(simData
            .map((elm) => SimCardModel(
                number: elm.number == "" ? null : elm.number,
                name: elm.displayName,
                company: elm.carrierName,
                slotNumber: int.tryParse(elm.slotIndex) ?? 0))
            .toList());
      }
    }catch(err){
          return MyDataState.DataFailed(err.toString());
        }
    }

    SmsService? listenIncomingSms(){
        try{
          _smsReader = MySmsReader.Readsms();
          _smsReader?.read();
          return this;
        }catch(err){
          if (kDebugMode) print(err);
          return null;
        }
    }

    Future<MyDataState.DataState<String,String>> startListening({required StreamController<SmsModel> smsStreamController}) async {
        try{
          PermissionStatus status = await grantPermissions();
          if(status == PermissionStatus.denied) return const MyDataState.DataFailed("Can't grant permissions !");
          _smsReader?.smsStream.listen((MySmsReader.SMS sms)=>_onData(sms,smsStreamController));
          return const MyDataState.DataSuccess("Star listening ...");
        }catch(err){
          if (kDebugMode) print(err);
          return MyDataState.DataFailed(err.toString());
        }
    }

    void _onData(MySmsReader.SMS sms,StreamController<SmsModel> smsStreamController){
        smsStreamController.add(SmsModel(sender: sms.sender, body: sms.body, receivedAt: sms.timeReceived));
    }

    Future<MyDataState.DataState<String,String>> stopListening() async {
        try{
          PermissionStatus status = await grantPermissions();
          if(status == PermissionStatus.denied) return const MyDataState.DataFailed("Can't grant permissions !");
          _smsReader?.dispose();
          return const MyDataState.DataSuccess("Stop listening .");
        }catch(err){
          if (kDebugMode) print(err);
          return MyDataState.DataFailed(err.toString());
        }
    }

}
