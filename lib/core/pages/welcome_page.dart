import 'dart:async';

import 'package:flutter/material.dart';
import 'package:recharge_by_scan/config/routes/routes.dart';
import 'package:recharge_by_scan/core/constants/app_images.dart';
import 'package:recharge_by_scan/core/widgets/theme_button.dart';

import '../util/custom_navigation_helper.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  late Timer _timer;

  @override
  void initState() {
    _timer = Timer(const Duration(seconds: 3), _simulateClick);
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _simulateClick(){
    CustomNavigationHelper.router.push(AppRoutes.homePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: _buildBody(),
      //bottomNavigationBar: _buildNavigationBar(),
    );
  }

  _buildBody() {
    return Container(
      color: Colors.transparent,
      width: double.infinity,
      child:Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Image.asset(
                    AppImages.logoLightImage,
                    width: 180,
                ),
                const SizedBox(height: 30),
                Text(
                  "WELCOME !",
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).colorScheme.onPrimary
                  ),
                ),
                const SizedBox(height: 10,),
               const Text(
                    "Manage your SIMs easely",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500
                    ),
                ),
               const Spacer(),
              ],
            ),
          )
    );
  }

}
