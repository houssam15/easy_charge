import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:recharge_by_scan/core/pages/home_page.dart';
import 'package:recharge_by_scan/core/pages/settings_page.dart';
import 'package:recharge_by_scan/core/util/local_storage.dart';
import "package:recharge_by_scan/features/recharge_by_scan/recharge_by_scan.dart" as RechargeByScanFeature;

import '../../core/model/local_storage/secure_item.dart';
import '../../core/pages/bottom_navigation_page.dart';
import '../../core/util/custom_navigation_helper.dart';
import '../../injection_container.dart';

class AppRoutes{
  static final GlobalKey<NavigatorState> parentNavigatorKey = GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> homeTabNavigatorKey = GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> settingsTabNavigatorKey = GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState>  rechargeTabNavigatorKey= GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> rechargeGuideTabNavigatorKey= GlobalKey<NavigatorState>();
  static const String homePath = '/home';
  static const String settingsPath = '/settings';
  static const String rechargePath = '/home/recharge';
  static const String rechargeGuidePath = '/home/recharge/guide';

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
                   child:const RechargeByScanFeature.RechargePage(),
                   state: state,
                 );
               },
             ),
           ],
         ),
         StatefulShellBranch(
           navigatorKey: rechargeGuideTabNavigatorKey,
           routes: [
             GoRoute(
               path: rechargeGuidePath,
               pageBuilder: (context, state) {
                 return CustomNavigationHelper.getPage(
                   child:const RechargeByScanFeature.OnBoardPage(),
                   state: state,
                 );
               },
               redirect: (context, state) async{
                  SecItemModel? r1 = await sl.get<LocalStorage>().getOne(LocalStorage.DISABLE_SKIP_ONBOARD_PAGE);
                  SecItemModel? r2 = await sl.get<LocalStorage>().getOne(LocalStorage.IS_ONBOARD_PASSED);
                  if(r1?.value==LocalStorage.FALSE && r2?.value==LocalStorage.TRUE) {
                    return rechargePath;
                  }else if(r1?.value==LocalStorage.FALSE){
                    await sl.get<LocalStorage>().add([SecItemModel(LocalStorage.IS_ONBOARD_PASSED,  LocalStorage.TRUE)]);
                    return rechargeGuidePath;
                  }else{
                    return rechargeGuidePath;
                  }
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

   ];
}