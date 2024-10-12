import "package:flutter/material.dart";
import "package:recharge_by_scan/core/widgets/operators_list.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  _buildBody(){
    return Column(
      children: [
        Text("Supported operators"),
        OperatorsList()
      ],
    );
  }
}
