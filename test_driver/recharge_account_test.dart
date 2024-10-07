import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:recharge_by_scan/features/recharge_by_scan/domain/entities/recharge.dart';
import 'package:recharge_by_scan/features/recharge_by_scan/domain/usecases/listen_incoming_sms.dart';
import 'package:recharge_by_scan/features/recharge_by_scan/domain/usecases/recharge_account.dart';
import 'package:recharge_by_scan/features/recharge_by_scan/service/sms.dart';
import 'package:recharge_by_scan/injection_container.dart';
import 'package:recharge_by_scan/features/recharge_by_scan/domain/usecases/get_user_accounts.dart';
import 'package:recharge_by_scan/core/resources/data_state.dart';
import 'package:recharge_by_scan/features/recharge_by_scan/domain/entities/sim_card.dart';

//flutter drive --driver=test_driver/main_test.dart --target=test_driver/recharge_account_test.dart

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    await initializeDependencies();
  });
  List<SimCardEntity> userAccounts  = [];
  group("Test recharge account Feature", (){

    testWidgets("Get user accounts", (WidgetTester tester) async {
      GetUserAccountsUseCase _getUserAccountUsecase = GetUserAccountsUseCase(sl());
      final result = await _getUserAccountUsecase();
      if(result is DataSuccess) userAccounts  = result.data!;
      expect(result, isA<DataSuccess<List<SimCardEntity>, String>>());
      expect(userAccounts.isNotEmpty, true, reason: "No user accounts retrieved.");
    });

    testWidgets("Send sms", (WidgetTester tester) async {
      assert(userAccounts.isNotEmpty, "No user accounts available for recharge.");
      RechargeAccountUseCase _rechargeAccountUsecase = RechargeAccountUseCase(sl());
      final result = await _rechargeAccountUsecase(params:RechargeEntity(
          code: "123455",
          offer: "2",
          simCard:userAccounts[1]));
      expect(result, isA<DataSuccess>());
    });

    testWidgets("Listen Incoming SMS", (WidgetTester tester) async {
      ListenIncomingSmsUseCase _listenIncomingSmsUsecase = ListenIncomingSmsUseCase(sl());
      final result = await _listenIncomingSmsUsecase();
      expect(result, isA<DataState<String,String>>());
    });
  });
}
