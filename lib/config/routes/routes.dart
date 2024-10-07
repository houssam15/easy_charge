import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:recharge_by_scan/core/constants/constants.dart';
import "package:recharge_by_scan/features/recharge_by_scan/recharge_by_scan.dart" as RechargeByScanFeature;
class AppRoutes{
  final GoRouter _router = GoRouter(
    initialLocation: initialRoute,
    routes: <RouteBase>[
      GoRoute(
        path: RechargeByScanFeature.HomeScreen.route,
        builder: (BuildContext context, GoRouterState state) {
          return const RechargeByScanFeature.HomeScreen();
        }
      ),
    ],
  );

  GoRouter get router => _router;
}