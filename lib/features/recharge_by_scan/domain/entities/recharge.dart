import "package:equatable/equatable.dart";
import "package:recharge_by_scan/features/recharge_by_scan/domain/entities/sim_card.dart";

class RechargeEntity extends Equatable{
  final String  code;
  final String  offer;
  final SimCardEntity  simCard;
  const RechargeEntity({
    required this.code,
    required this.offer,
    required this.simCard,
  });

  @override
  List<Object?> get props => [
    code,
    offer,
    simCard
  ];
}