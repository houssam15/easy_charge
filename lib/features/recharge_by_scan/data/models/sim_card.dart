
import 'package:recharge_by_scan/features/recharge_by_scan/domain/entities/sim_card.dart';

class SimCardModel extends SimCardEntity{

  SimCardModel({
    required String number,
    required String name,
    required int slotNumber
  }):super(
    number: number,
    name: name,
    slotNumber: slotNumber
  );

  factory SimCardModel.fromEntity(SimCardEntity e){
    return SimCardModel(
        number: e.number,
        name: e.name,
        slotNumber: e.slotNumber
    );
  }

  SimCardEntity toEntity(){
    return SimCardEntity(
        number: number,
        name: name,
        slotNumber: slotNumber
    );
  }

  static List<SimCardEntity> toEntities(List<SimCardModel> cards){
    return cards.map((card)=>card.toEntity()).toList();
  }


}