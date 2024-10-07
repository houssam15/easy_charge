import 'package:recharge_by_scan/core/resources/data_state.dart';
import 'package:recharge_by_scan/core/usecases/usecase.dart';
import 'package:recharge_by_scan/features/recharge_by_scan/domain/entities/recharge.dart';
import 'package:recharge_by_scan/features/recharge_by_scan/domain/repository/recharge_repository.dart';

class RechargeAccountUseCase implements UseCase<DataState,RechargeEntity>{
  final RechargeRepository _rechargeRepository;

  const RechargeAccountUseCase(this._rechargeRepository);

  @override
  Future<DataState> call({RechargeEntity? params}) {
    return _rechargeRepository.rechargeAccount(params!);
  }
  
}