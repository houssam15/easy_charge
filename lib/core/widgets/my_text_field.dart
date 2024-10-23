import "package:flutter/material.dart";

class MyTextField extends StatefulWidget {
  MyTextField(this.controller,{super.key});
  final TextEditingController controller;
  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration:const InputDecoration(
        border: OutlineInputBorder(),
      ),
    );
  }
}
