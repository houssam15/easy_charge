import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:recharge_by_scan/core/pages/home_page.dart';
import 'package:recharge_by_scan/core/pages/settings_page.dart';
import 'package:recharge_by_scan/core/pages/welcome_page.dart';
import "package:recharge_by_scan/features/recharge_by_scan/recharge_by_scan.dart" as RechargeByScanFeature;

import '../../core/pages/bottom_navigation_page.dart';
import '../../core/util/custom_navigation_helper.dart';

class AppRoutes{
  static final GlobalKey<NavigatorState> parentNavigatorKey = GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> homeTabNavigatorKey = GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> settingsTabNavigatorKey = GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState>  rechargeTabNavigatorKey= GlobalKey<NavigatorState>();

  static const String welcomePath = "/";
  static const String homePath = '/home';
  static const String settingsPath = '/settings';

  static const String rechargePath = '/home/recharge';

  static final main_pages_routes = [
     StatefulShellRoute.indexedStack(
       parentNavigatorKey: parentNavigatorKey,
       branches: [
         StatefulShellBranch(
           navigatorKey: homeTabNavigatorKey,
           routes: [
             GoRoute(
               path: homePath,
               pageBuilder: (context, GoRouterState state) {
                 return CustomNavigationHelper.getPage(
                   child: const HomePage(),
                   state: state,
                 );
               },
             ),
           ],
         ),
         StatefulShellBranch(
           navigatorKey: settingsTabNavigatorKey,
           routes: [
             GoRoute(
               path: settingsPath,
               pageBuilder: (context, state) {
                 return CustomNavigationHelper.getPage(
                   child: const SettingsPage(),
                   state: state,
                 );
               },
             ),
           ],
         ),
         StatefulShellBranch(
           navigatorKey: rechargeTabNavigatorKey,
           routes: [
             GoRoute(
               path: rechargePath,
               pageBuilder: (context, state) {
                 return CustomNavigationHelper.getPage(
                   child:const RechargeByScanFeature.RechargeScreen(),
                   state: state,
                 );
               },
             ),
           ],
         ),
       ],
       pageBuilder:  (
           BuildContext context,
           GoRouterState state,
           StatefulNavigationShell navigationShell,
           ){
         return CustomNavigationHelper.getPage(
           child: BottomNavigationPage(
             child: navigationShell,
           ),
           state: state,
         );
       },
     )
   ];

   static final other_routes = [
     GoRoute(
       parentNavigatorKey: parentNavigatorKey,
       path: welcomePath,
       pageBuilder: (context, state) {
         return CustomNavigationHelper.getPage(
           child: const WelcomePage(),
           state: state,
         );
       },
     ),
   ];
}