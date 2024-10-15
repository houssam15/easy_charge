
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recharge_by_scan/core/constants/app_images.dart';
import 'package:recharge_by_scan/features/recharge_by_scan/domain/entities/offer.dart';

enum Operator{TISALAT,ORANGE,INWI,UNKOWN}

class SimCardEntity {
  final String number;
  final String name;
  final int slotNumber;

  SimCardEntity({required this.number,required this.name,required this.slotNumber});

  Operator operator = Operator.UNKOWN;

  bool isKnown(){
    return Operator.values.where((elm)=>elm.toString() == name.toUpperCase()).isNotEmpty;
  }
  
  String getOperatorPicture(Operator operator){
    switch(operator){
      case Operator.TISALAT: return AppImages.tisalatOperatorImage;
      case Operator.ORANGE: return AppImages.orangeOperatorImage;
      case Operator.INWI: return AppImages.inwiOperatorImage;
      default: return AppImages.tisalatOperatorImage;
    }
  }

  SimCardEntity getOperator(){
    for(Operator o in Operator.values.where((elm)=>elm!=Operator.UNKOWN)){
      if(RegExp(o.toString().split('.').last, caseSensitive: false).hasMatch(name)){
        operator = o;
        break;
      }
    }
    return this;
  }

  List<String> getOffers(){
     switch(operator){
       case Operator.TISALAT: return ["*1","*2","*22","*3","*4","*5","*6","*7","*77","*78","*8","*88","*9"];
       case Operator.ORANGE: return ["*1","*2","*3","*4"];
       case Operator.INWI: return ["*1","*2","*3","*4","*5","*6","*7","*8","*9"];
       default: return [];
     }
  }

}