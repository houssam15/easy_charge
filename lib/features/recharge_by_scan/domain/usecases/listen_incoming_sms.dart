import 'package:recharge_by_scan/core/resources/data_state.dart';
import 'package:recharge_by_scan/core/usecases/usecase.dart';
import 'package:recharge_by_scan/features/recharge_by_scan/domain/entities/recharge.dart';
import 'package:recharge_by_scan/features/recharge_by_scan/domain/entities/sim_card.dart';
import 'package:recharge_by_scan/features/recharge_by_scan/domain/repository/recharge_repository.dart';

import '../entities/sms.dart';


class ListenIncomingSmsUseCase implements UseCase<DataState<Stream<SmsEntity>?,String>,bool>{
  final RechargeRepository _rechargeRepository;

  const ListenIncomingSmsUseCase(this._rechargeRepository);

  @override
  Future<DataState<Stream<SmsEntity>?,String>> call({bool params=true})async{
    return await _rechargeRepository.listenIncomingSms(activate:params);
  }

}