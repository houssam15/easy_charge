import "package:flutter/material.dart";

ThemeData theme(){
  return ThemeData(
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: appBarTheme()
  );
}

AppBarTheme appBarTheme(){
  return const AppBarTheme(
    color: Colors.white,
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(color: Color(0XFF888888)),
    titleTextStyle: TextStyle(color: Color(0XFF888888),fontSize: 18)
  );
}