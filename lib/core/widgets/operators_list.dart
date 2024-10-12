import "package:flutter/material.dart";
import "package:recharge_by_scan/core/widgets/operator_item.dart";

class OperatorsList extends StatefulWidget {
  const OperatorsList({super.key});

  @override
  State<OperatorsList> createState() => _OperatorsListState();
}

class _OperatorsListState extends State<OperatorsList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(8.0),
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 1.9,
        children: List.generate(4, (index)=>OperatorItem(index: index)),
      ),
    );
  }
}
