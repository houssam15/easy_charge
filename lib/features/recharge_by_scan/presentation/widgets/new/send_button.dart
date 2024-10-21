import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class SendButtonWidget extends StatelessWidget {
  const SendButtonWidget({super.key,required this.onTap,this.isProcessing=false});
  final dynamic onTap;
  final bool isProcessing;

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
      onPressed: onTap,
      child:isProcessing?
          SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary
              )
          )
          :Text(
        "Send",
        style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 14
        ),
      ),
    );
  }
}
