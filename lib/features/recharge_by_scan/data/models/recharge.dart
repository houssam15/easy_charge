import 'package:recharge_by_scan/core/constants/operators_enum.dart';
import 'package:recharge_by_scan/features/recharge_by_scan/data/models/sim_card.dart';
import 'package:recharge_by_scan/features/recharge_by_scan/domain/entities/recharge.dart';

class RechargeModel extends RechargeEntity{
  RechargeModel({
      required super.code,
      required super.offer,
      required SimCardModel simCard,
  }):super(
    simCard: simCard.toEntity(),
  );


  factory RechargeModel.fromEntity(RechargeEntity e) {
    return RechargeModel(
      code: e.code,
      offer: e.offer,
      simCard: SimCardModel.fromEntity(e.simCard),
    );
  }


  String getMessage(Operator operator){
    switch(operator){
      case Operator.TISALAT:return "$code$offer";
      case Operator.ORANGE:return "$code$offer";
      case Operator.INWI: return "*120*20*$code$offer#";
      default :"$code$offer";
    }
    return "$code$offer";
  }

}