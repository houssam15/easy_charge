import "package:flutter/material.dart";

class ConfimationAlertWidget extends StatelessWidget {
  const ConfimationAlertWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Confirm"),
      content: Text('you will loose your scanned data ?'),
      actions: [
        TextButton(
            onPressed: (){
              Navigator.of(context).pop(false);
            },
            child: Text('No')
        ),
        TextButton(
            onPressed: (){
              Navigator.of(context).pop(true);
            },
            child: Text('Yes')
        )
      ],
    );
  }
}
