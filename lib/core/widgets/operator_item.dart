import "package:flutter/material.dart";

class OperatorItem extends StatefulWidget {
  final int index;
  const OperatorItem({super.key,required this.index});

  @override
  State<OperatorItem> createState() => _OperatorItemState();
}

class _OperatorItemState extends State<OperatorItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 4.0,
        child: Center(
          child: Text('Card ${widget.index+1}'),
        ),
    );
  }
}
