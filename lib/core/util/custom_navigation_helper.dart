import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recharge_by_scan/config/routes/routes.dart';
import 'package:recharge_by_scan/core/constants/constants.dart';

/*
CustomNavigationHelper.router.push(
                  CustomNavigationHelper.detailPath,
);
*/

class CustomNavigationHelper{
  static final CustomNavigationHelper _instance = CustomNavigationHelper._internal();
  static CustomNavigationHelper get instance => _instance;
  static late final GoRouter router;

  BuildContext get context =>
      router.routerDelegate.navigatorKey.currentContext!;

  GoRouterDelegate get routerDelegate => router.routerDelegate;

  GoRouteInformationParser get routeInformationParser => router.routeInformationParser;

  factory CustomNavigationHelper() {
    return _instance;
  }

  CustomNavigationHelper._internal() {
    router =  GoRouter(
      navigatorKey: AppRoutes.parentNavigatorKey,
      initialLocation: initialRoute,
      routes: [...AppRoutes.main_pages_routes,...AppRoutes.other_routes],
    );
  }

  static Page getPage({
    required Widget child,
    required GoRouterState state,
  }) {
    return MaterialPage(
      key: state.pageKey,
      child: child,
    );
  }
}