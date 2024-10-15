import 'package:flutter/material.dart';

class OfferEntity{
    final String code;
    String? label;
    List<IconData> icons;
    Color color;

    OfferEntity({
      required this.code,
      this.label,
      this.color = Colors.white,
      this.icons = const []
    });
}