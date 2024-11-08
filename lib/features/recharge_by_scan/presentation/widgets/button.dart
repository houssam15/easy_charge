import "package:flutter/material.dart";

class ButtonWidget extends StatefulWidget {
  ButtonWidget({super.key,required this.onPressed,required this.icon,required this.text});
  final dynamic onPressed;
  final IconData icon;
  final String text;
  @override
  State<ButtonWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5), // Adjust the border radius
            side: BorderSide(color: Theme.of(context).colorScheme.primary , width: 2), // Border color and width
          ),
          elevation: 5, // Adjust elevation for shadow effect if needed
        ),
        child:Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon),
              const SizedBox(width: 5),
              Text(widget.text)
            ],
          ),
        )
    );
  }
}
