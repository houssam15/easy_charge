import "dart:math";

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../domain/entities/sim_card.dart";
import "../bloc/remote/recharge_account/remote_recharge_account_bloc.dart";
import "../bloc/remote/recharge_account/remote_recharge_account_state.dart";
import "../widgets/new/sim_card.dart";
import "../widgets/new/step.dart";

class RechargePage extends StatefulWidget {
  const RechargePage({super.key});

  @override
  State<RechargePage> createState() => _RechargePageState();
}

class _RechargePageState extends State<RechargePage> {
  List<SimCardEntity> simCards = [];
  SimCardEntity? selectedSimCard;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: _buildAppbar(),
      body: _buildBody(),
    );
  }

  _buildAppbar(){
    return AppBar(
      title: Center(
          child: Text(
              "Recharge account",
              style: TextStyle(
                fontWeight: FontWeight.w500
              ),
          )
      ),
      automaticallyImplyLeading: false,
    );
  }

  _buildBody(){
    return BlocConsumer<RemoteRechargeAccountBloc,RemoteRechargeAccountState>(
      listener: (context,state){
        if(state is RemoteRechargeAccountInitialState){
          setState(() {
            simCards = state.data;
            selectedSimCard = simCards[0];
          });
        }
      },
      builder: (context,state){
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 8.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                const StepWidget(step: "1",label: "Choose your card"),
                const SizedBox(height: 10),
                Row(
                  children: simCards.map<Widget>(
                      (elm)=>SimCardWidget(simCard: elm)
                  ).toList(),
                ),
                const SizedBox(height: 20),
                const StepWidget(step: "2",label: "Choose your offer"),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8.0, // gap between adjacent chips
                  runSpacing: 4.0, // gap between lines
                  children :selectedSimCard==null?[]:selectedSimCard!
                      .getOperator()
                      .getOffers()
                      .map((elm)
                      =>Chip(
                          label: Text(elm),
                          color: WidgetStateProperty.all<Color>(
                              Theme.of(context).colorScheme.primary.withOpacity(Random().nextDouble())
                          ),
                      )).toList()
                      ,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
