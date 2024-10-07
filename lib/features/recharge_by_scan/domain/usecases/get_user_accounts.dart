import 'package:recharge_by_scan/core/resources/data_state.dart';
import 'package:recharge_by_scan/core/usecases/usecase.dart';
import 'package:recharge_by_scan/features/recharge_by_scan/domain/entities/recharge.dart';
import 'package:recharge_by_scan/features/recharge_by_scan/domain/entities/sim_card.dart';
import 'package:recharge_by_scan/features/recharge_by_scan/domain/repository/recharge_repository.dart';


class GetUserAccountsUseCase implements UseCase<DataState<List<SimCardEntity>,String>,void>{
  final RechargeRepository _rechargeRepository;

  const GetUserAccountsUseCase(this._rechargeRepository);

  @override
  Future<DataState<List<SimCardEntity>,String>> call({void params}) {
    return _rechargeRepository.getUserAccounts();
  }

}