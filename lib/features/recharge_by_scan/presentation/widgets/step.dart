import "package:flutter/material.dart";

class StepWidget extends StatelessWidget {
  const StepWidget({super.key,required this.step,required this.label});
  final String step;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Row(
        children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10)
              ),
              child: Center(
                child: Text(
                  step,
                  style:const TextStyle(
                    fontWeight: FontWeight.w900
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
                label,
                style:const TextStyle(
                  fontWeight: FontWeight.w500
                ),
            )
        ],
      ),
    );
  }
}

