import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../domain/entities/recharge.dart";
import "../../domain/entities/sim_card.dart";
import "../bloc/remote/recharge_account/remote_recharge_account_bloc.dart";
import "../bloc/remote/recharge_account/remote_recharge_account_event.dart";

class RechargeButton extends StatefulWidget {
  final SimCardEntity? selectedSimCard;
  const RechargeButton({super.key,required this.selectedSimCard,});

  @override
  State<RechargeButton> createState() => _RechargeButtonState();
}

class _RechargeButtonState extends State<RechargeButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue, // Set button background color to blue
        foregroundColor: Colors.white, // Set button text color to white
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Slight border radius
        ),
      ),
      onPressed: () {
        context.read<RemoteRechargeAccountBloc>().add(
          RemoteRechargeAccount(
            RechargeEntity(
              code: "123456789", // Sample recharge code
              simCard: widget.selectedSimCard!, // Selected SIM card
              offer: "*100", // Example offer
            ),
          ),
        );
      }
       , // Disable button if no SIM card is selected
      child: const Text("Recharge"),
    );
  }
}
