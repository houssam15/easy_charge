import "dart:math";

import "package:flutter/material.dart";

class OfferWidget extends StatelessWidget {
  const OfferWidget({super.key,required this.offer,this.onTap,this.isSelected = true});
  final String offer;
  final dynamic onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
              onTap: onTap,
              child: Chip(
                        label: Text(offer),
                        color: WidgetStateProperty.all<Color>(
                              isSelected?Theme.of(context).colorScheme.primary.withOpacity(Random().nextDouble()):Colors.grey
                        )
              ),
    );
  }
}
