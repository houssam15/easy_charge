import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:recharge_by_scan/features/recharge_by_scan/presentation/widgets/new/offer.dart";
import "package:recharge_by_scan/features/recharge_by_scan/presentation/widgets/new/send_button.dart";
import "../../domain/entities/sim_card.dart";
import "../bloc/remote/recharge_account/remote_recharge_account_bloc.dart";
import "../bloc/remote/recharge_account/remote_recharge_account_event.dart";
import "../bloc/remote/recharge_account/remote_recharge_account_state.dart";
import "../widgets/new/code.dart";
import "../widgets/new/confirmation_alert.dart";
import "../widgets/new/scan_alert_content.dart";
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
  List<int> visibleSteps = [1];
  String? selectedOffer;
  String? scannedCode;

  @override
  void initState() {
    context.read<RemoteRechargeAccountBloc>().add(const RemoteRechargeAccountInitial());
    super.initState();
  }

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
            //selectedSimCard = simCards[0];
          });
        }
      },
      builder: (context,state){
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 8.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                      "Please follow steps below to recharge your account",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.4)
                      ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  //step 1 : choose sim
                  if(visibleSteps.contains(1))
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      const StepWidget(step: "1",label: "Choose your card"),
                      const SizedBox(height: 10),
                      Row(
                        children: simCards.map<Widget>(
                                (elm)=>SimCardWidget(
                                    simCard: elm,
                                    onTap:()async{
                                      bool canContinue = true;
                                      if(selectedSimCard is SimCardEntity && scannedCode is String){
                                        canContinue = await showDialog(
                                                context: context,
                                                builder: (BuildContext context){
                                                  return const ConfimationAlertWidget();
                                                });
                                      }
                                      if(canContinue==false) return;
                                      selectedSimCard = elm;
                                      selectedOffer = null;
                                      scannedCode = null;
                                      if(!visibleSteps.contains(2)) visibleSteps.add(2);
                                      else{
                                        visibleSteps.remove(3);
                                        visibleSteps.remove(4);
                                      }
                                      setState(() {});
                                    },
                                    isSelected: selectedSimCard==elm
                                )
                        ).toList(),
                      ),
                    ],
                  ),
                  if(visibleSteps.contains(2))
                  //step 2 : choose offer
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      const StepWidget(step: "2",label: "Choose your offer"),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8.0, // gap between adjacent chips
                        runSpacing: 4.0, // gap between lines
                        children :selectedSimCard==null?[]:selectedSimCard!
                            .getOperator()
                            .getOffers()
                            .map((elm) => OfferWidget(
                                          isSelected:selectedOffer==elm,
                                          offer: elm,
                                          onTap:(){
                                            selectedOffer = elm;
                                            if(!visibleSteps.contains(3)) visibleSteps.add(3);
                                            setState(() {});
                                          }
                             ))
                            .toList(),
                      )
                    ],
                  ),
                  if(visibleSteps.contains(3))
                  //step 3 : scan code
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      const StepWidget(step: "3",label: "Scan your recharge"),
                      const SizedBox(height: 10),
                      scannedCode==null?
                      ElevatedButton(
                          onPressed: (){
                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>AlertDialog(
                                    content: ScanAlertContentWidget(
                                        codeLength:selectedSimCard?.getCodeLength(),
                                        onDone: (BuildContext context,String text){
                                          if(scannedCode is String && scannedCode!.isNotEmpty) return;
                                          Navigator.of(context).pop();
                                          scannedCode = text;
                                          if(!visibleSteps.contains(4)) visibleSteps.add(4);
                                          setState(() {});
                                        }
                                    )
                                )
                            );
                          },
                          child:const Center(
                            child: Text("Scan"),
                          )
                      ):
                      const Text(
                        "scanned succesfully",
                        style: TextStyle(
                            color: Colors.green
                        ),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                  if(visibleSteps.contains(4))
                  //step 4 : send sms
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      const StepWidget(step: "4",label: "Send Sms"),
                      const SizedBox(height:20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CodeWidget(code:scannedCode!),
                          const SizedBox(width: 5),
                          OfferWidget(offer: selectedOffer!),
                          const SizedBox(width: 5),
                          const SendButtonWidget()
                        ],
                      )
                    ],
                  ),

                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
