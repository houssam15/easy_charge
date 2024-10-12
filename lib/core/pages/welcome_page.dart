import 'package:flutter/material.dart';
import 'package:recharge_by_scan/config/routes/routes.dart';
import 'package:recharge_by_scan/core/widgets/theme_button.dart';

import '../util/custom_navigation_helper.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: _buildBody(),
      bottomNavigationBar: _buildNavigationBar(),
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
                Image.asset(
                    "assets/imgs/logo-light.png",
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
                )
              ],
            ),
          )
    );
  }
  _buildNavigationBar(){
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50)
        )
      ),
      child: Center(
        child: ThemeButton(
                  label: "NEXT",
                  labelSize: 22,
                  labelColor: Theme.of(context).colorScheme.onPrimary,
                  color: Theme.of(context).colorScheme.primary,
                  width: 300,
                  height: 80,
                  onClick: (){
                    CustomNavigationHelper.router.push(
                      AppRoutes.homePath,
                    );
                  }
        ),
      ),
    );
  }
}