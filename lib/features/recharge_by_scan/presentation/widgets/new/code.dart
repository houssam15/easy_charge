import "dart:math";

import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class CodeWidget extends StatelessWidget {
  const CodeWidget({super.key,required this.code});
  final String code;

  String _separateStringIntoPairs(String str){
    if(str.length % 2 != 0){
      if(kDebugMode) print("Input string length must be even.");
      return str;
    }else{
      final buffer = StringBuffer();
      for(var i = 0;i < str.length;i+=2){
        buffer.write(str.substring(i,i+2));
        if(i<str.length - 2){
          buffer.write(' ');
        }
      }
      return buffer.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Chip(
        label: Text(_separateStringIntoPairs(code)),
        color: WidgetStateProperty.all<Color>(
            Theme.of(context).colorScheme.primary.withOpacity(Random().nextDouble())
        )
    );
  }
}
