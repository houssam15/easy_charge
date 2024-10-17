import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class SendButtonWidget extends StatelessWidget {
  const SendButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor:WidgetStateProperty.all(
            Colors.white
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2.0
            )
          ),
        )
      ),
      onPressed: () {},
      child: Text(
        "Send",
        style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 14
        ),
      ),
    );
  }
}
