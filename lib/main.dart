import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recharge_by_scan/config/theme/app_themes.dart';
import 'package:recharge_by_scan/features/recharge_by_scan/presentation/bloc/remote/recharge_account/remote_recharge_account_bloc.dart';
import 'package:recharge_by_scan/features/recharge_by_scan/presentation/bloc/remote/recharge_account/remote_recharge_account_event.dart';
import 'package:recharge_by_scan/injection_container.dart';
import "package:recharge_by_scan/features/recharge_by_scan/presentation/pages/home/recharge_account.dart";

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({Key? key}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RemoteRechargeAccountBloc>(
        create: (context) => sl()..add(const RemoteRechargeAccountInitial()),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme(),
          home : const RechargeAccountScreen()
      ),
    );
  }
}