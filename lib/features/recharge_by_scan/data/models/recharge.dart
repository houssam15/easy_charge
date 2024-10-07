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

  String getMessage(){
    return "$code*$offer";
  }




}