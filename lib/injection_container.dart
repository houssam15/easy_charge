import "package:get_it/get_it.dart";
import "package:dio/dio.dart";
import "package:recharge_by_scan/core/util/local_storage.dart";
import "package:recharge_by_scan/features/recharge_by_scan/data/data_sources/remote/recharge_api_service.dart";
import "package:recharge_by_scan/features/recharge_by_scan/data/repository/recharge_repository_impl.dart";
import "package:recharge_by_scan/features/recharge_by_scan/domain/repository/recharge_repository.dart";
import "package:recharge_by_scan/features/recharge_by_scan/domain/usecases/listen_incoming_sms.dart";
import "package:recharge_by_scan/features/recharge_by_scan/domain/usecases/recharge_account.dart";
import "package:recharge_by_scan/features/recharge_by_scan/presentation/bloc/remote/recharge_account/remote_recharge_account_bloc.dart";
import "package:recharge_by_scan/features/recharge_by_scan/service/sms.dart";

import "core/util/custom_navigation_helper.dart";
import "features/recharge_by_scan/domain/usecases/get_user_accounts.dart";
final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  //Initialize Settings
  sl.registerSingleton<LocalStorage>(await LocalStorage().initialize());
  //Dio
  sl.registerSingleton<Dio>(Dio());
  //Dependencies
  sl.registerSingleton<SmsService>(SmsService());
  sl.registerSingleton<RechargeRepository>(RechargeRepositoryImpl(sl()));
  //Usecases
  sl.registerSingleton<RechargeAccountUseCase>(RechargeAccountUseCase(sl()));
  sl.registerSingleton<GetUserAccountsUseCase>(GetUserAccountsUseCase(sl()));
  sl.registerSingleton<ListenIncomingSmsUseCase>(ListenIncomingSmsUseCase(sl()));
  //Blocs
  sl.registerFactory<RemoteRechargeAccountBloc>(
      () => RemoteRechargeAccountBloc(sl(),sl(),sl())
  );
  //Routes
  CustomNavigationHelper.instance;
}