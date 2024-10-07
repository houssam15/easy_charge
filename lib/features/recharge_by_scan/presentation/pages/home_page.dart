import "package:flutter/material.dart";
import "package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart";

import "../widgets/persisted_menu.dart";

class HomeScreen extends StatefulWidget {
  static String route = "/features/recharge_by_scan";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body:Center(child:Text("hello")),
      bottomNavigationBar: const PersistedMenuWidget(),
    );
  }


  _buildAppbar(){
    return AppBar(
      title: Text("Home"),
    );
  }


}
