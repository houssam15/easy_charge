import "package:flutter/material.dart";

class OperatorItem extends StatefulWidget {
  final String image;

  const OperatorItem({super.key,required this.image});

  @override
  State<OperatorItem> createState() => _OperatorItemState();
}

class _OperatorItemState extends State<OperatorItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      margin: EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
          image: DecorationImage(
              image: AssetImage(widget.image),
              fit: BoxFit.cover
          )// Makes the container circular
      ),
    );
  }
}
