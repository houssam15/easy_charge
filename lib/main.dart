import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recharge_by_scan/config/theme/app_themes.dart';
import 'package:recharge_by_scan/features/recharge_by_scan/presentation/bloc/remote/recharge_account/remote_recharge_account_bloc.dart';
import 'package:recharge_by_scan/features/recharge_by_scan/presentation/bloc/remote/recharge_account/remote_recharge_account_event.dart';
import 'package:recharge_by_scan/injection_container.dart';
import 'core/util/custom_navigation_helper.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);

  runApp(const App());
}

class App extends StatelessWidget{
  const App({Key? key}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RemoteRechargeAccountBloc>(
        create: (context) => sl()..add(const RemoteRechargeAccountInitial()),
      child: MaterialApp.router(
        scaffoldMessengerKey: scaffoldMessengerKey,
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        theme: GlobalThemData.lightThemeData,
        darkTheme: GlobalThemData.darkThemeData,
        routerConfig: CustomNavigationHelper.router,
      ),
    );
  }
}

