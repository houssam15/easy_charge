import "package:flutter/material.dart";

class MyTextField extends StatefulWidget {
  MyTextField(this.controller,{super.key,this.maxLength});
  final TextEditingController controller;
  final int? maxLength;
  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      maxLength:widget.maxLength ,
      keyboardType: TextInputType.number,
      decoration:const InputDecoration(
        border: OutlineInputBorder(),
      ),
    );
  }
}
