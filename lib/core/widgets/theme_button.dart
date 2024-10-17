import 'package:flutter/material.dart';

class ThemeButton extends StatelessWidget {

  String? label;
  Function onClick;
  Color? color;
  Color? highlight;
  Widget? icon;
  Color borderColor;
  Color labelColor;
  double borderWidth;
  double? width;
  double? height;
  double? labelSize;

  ThemeButton({
    this.label,
    this.labelColor = Colors.white,
    this.color ,
    this.highlight,
    this.icon,
    this.borderColor = Colors.transparent,
    this.borderWidth = 4,
    required this.onClick,
    this.width,
    this.height,
    this.labelSize
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: this.highlight,
      highlightColor: this.highlight,
      onTap: ()=>onClick(),
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Material(
              color: this.color,
              child: Container(
                  width: width,
                  height: height,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                          color: this.borderColor,
                          width: this.borderWidth)
                  ),
                  child: icon == null ?
                  Text(label!,
                      style: TextStyle(
                          fontSize: labelSize,
                          color: labelColor,
                          fontWeight: FontWeight.bold)) :
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(label!,
                          style: TextStyle(
                              fontSize: 16,
                              color: labelColor,
                              fontWeight: FontWeight.bold)
                      ),
                      const SizedBox(width: 10),
                      icon!,
                    ],
                  )
              ),
            )),
      ),
    );
  }
}