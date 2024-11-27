
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recharge_by_scan/core/constants/app_images.dart';
import 'package:recharge_by_scan/core/util/local_storage.dart';
import 'package:recharge_by_scan/features/recharge_by_scan/domain/entities/offer.dart';

import '../../../../core/constants/operators_enum.dart';
import '../../../../injection_container.dart';


class SimCardEntity {
  final String? number;
  final String? name;
  final int? slotNumber;
  final String? company;

  SimCardEntity({required this.number,required this.name,required this.slotNumber,required this.company});

  Operator operator = Operator.UNKNOWN;

  bool isKnown(){
    return Operator.values.where((elm)=>elm.toString() == name?.toUpperCase()).isNotEmpty;
  }
  
  String getOperatorPicture(Operator operator){
    switch(operator){
      case Operator.MAROC_TELECOM: return AppImages.tisalatOperatorImage;
      case Operator.ORANGE: return AppImages.orangeOperatorImage;
      case Operator.INWI: return AppImages.inwiOperatorImage;
      default: return AppImages.tisalatOperatorImage;
    }
  }

  SimCardEntity getOperator(){
    for(Operator o in Operator.values.where((elm)=>elm!=Operator.UNKNOWN)){
      if(RegExp(o.displayName, caseSensitive: false).hasMatch(company.toString())){
        operator = o;
        break;
      }
    }
    return this;
  }

  List<String> getOffers(){
     switch(operator){
       case Operator.MAROC_TELECOM: return ["*1","*2","*22","*3","*4","*5","*6","*7","*77","*78","*8","*88","*9",""];
       case Operator.ORANGE: return ["*1","*2","*3","*4",""];
       case Operator.INWI: return ["*1","*2","*3","*4","*5","*6","*7","*8","*9",""];
       default: return [];
     }
  }

  String getCodeLength(){
    switch(operator){
      case Operator.MAROC_TELECOM: return "14";
      case Operator.ORANGE: return "16";
      case Operator.INWI: return "16";
      default: return "14";
    }
  }

  Future<String> getRechargeNumber()async{
    switch(operator){
      case Operator.MAROC_TELECOM: return (await sl.get<LocalStorage>().getOne(LocalStorage.MAROC_TELECOM_SMS_NUMBER))?.value;
      case Operator.ORANGE: return (await sl.get<LocalStorage>().getOne(LocalStorage.ORANGE_SMS_NUMBER))?.value;
      case Operator.INWI: return (await sl.get<LocalStorage>().getOne(LocalStorage.INWI_SMS_NUMBER))?.value;
      default: return "unknown";
    }
  }

}