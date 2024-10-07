import 'package:recharge_by_scan/core/resources/data_state.dart';
import 'package:recharge_by_scan/features/recharge_by_scan/domain/entities/recharge.dart';
import 'package:recharge_by_scan/features/recharge_by_scan/domain/entities/sim_card.dart';
import 'package:recharge_by_scan/features/recharge_by_scan/domain/entities/sms.dart';


abstract class RechargeRepository{
  Future<DataState> rechargeAccount(RechargeEntity recharge);
  Future<DataState<List<SimCardEntity>,String>> getUserAccounts();
  Future<DataState<Stream<SmsEntity>?,String>> listenIncomingSms({required bool activate});

}