import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";
import "package:recharge_by_scan/config/routes/routes.dart";
import "package:recharge_by_scan/features/recharge_by_scan/presentation/widgets/button.dart";
import "package:recharge_by_scan/features/recharge_by_scan/presentation/widgets/offer.dart";
import "package:recharge_by_scan/features/recharge_by_scan/presentation/widgets/send_button.dart";
import "../../../../core/util/custom_navigation_helper.dart";
import "../../../../core/widgets/my_text_field.dart";
import "../../../../main.dart";
import "../../domain/entities/recharge.dart";
import "../../domain/entities/sim_card.dart";
import "../bloc/remote/recharge_account/remote_recharge_account_bloc.dart";
import "../bloc/remote/recharge_account/remote_recharge_account_event.dart";
import "../bloc/remote/recharge_account/remote_recharge_account_state.dart";
import "../widgets/code.dart";
import "../widgets/confirmation_alert.dart";
import "../widgets/received_sms.dart";
import "../widgets/scan_alert_content.dart";
import "../widgets/sim_card.dart";
import "../widgets/step.dart";

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
  bool isCodeValid = false;
  bool isProcessing = false;
  final ScrollController _scrollController = ScrollController();

  listenSms(bool activate){
    context.read<RemoteRechargeAccountBloc>().add(RemoteRechargeAccountListenSms(activate));
  }

  _saveCode(String code, {dynamic onDone}) {
    if(!RegExp(r'^\d{' + selectedSimCard!.getCodeLength() + r'}$').hasMatch(code)){
      isCodeValid = false;
      hideStep(4);
    }else{
      isCodeValid = true;
      showStep(4);
      _scrollToEnd();
    }
    scannedCode = code;
    setState(() {});
    onDone();
  }

  refreshStep3(){
    scannedCode = null;
    isCodeValid = false;
    hideStep(4);
    setState(() {});
  }

  hideStep(int step){
    if(isStepVisible(step)) visibleSteps.remove(step);
  }

  showStep(int step){
    if(!isStepVisible(step)) visibleSteps.add(step);
  }

  bool isStepVisible(int step){
    return visibleSteps.contains(step);
  }

  _openDialogForCode({String? text}){
    showDialog(
        context: context,
        builder: (BuildContext context){
          TextEditingController controller = TextEditingController(text: text);
          return AlertDialog(
            title:const Text("Edit code : "),
            content: MyTextField(controller,maxLength: int.tryParse(selectedSimCard!.getCodeLength())),
            actions: [
              TextButton(onPressed: () => context.pop(), child:const Text("Cancel")),
              TextButton(onPressed:() => _saveCode(
                  controller.value.text,
                  onDone: ()=>context.pop()
              ), child:const Text("Ok"))
            ],
          );
        }
    );
  }

  void _scrollToEnd() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent, // Scroll to end
      duration: const Duration(milliseconds: 500), // Animation duration
      curve: Curves.easeOut, // Animation curve
    );
  }

  @override
  void initState() {
    context.read<RemoteRechargeAccountBloc>().add(const RemoteRechargeAccountInitial());
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      //appBar: _buildAppbar(),
      body: _buildBody(),
    );
  }

  _buildAppbar(){
    return AppBar(
      title:const Center(
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
          });
        }

        if(state is RemoteRechargeAccountNewSmsReceivedStatus){
          listenSms(false);
          setState((){
            isProcessing = false;
          });
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showMaterialBanner(
            MaterialBanner(
                backgroundColor: Theme.of(context).colorScheme.primary,
                content:ReceivedSms(sms: state.data!),
                actions: [
                  TextButton(
                      onPressed: (){
                        if(mounted){
                          ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                        }else{
                          scaffoldMessengerKey.currentState?.hideCurrentMaterialBanner();
                        }
                      },
                      child: const Text(
                          "Ok",
                        style: TextStyle(
                          color: Colors.white
                        ),
                      )
                  )
                ]
            )
          );
        }
      },
      builder: (context,state){
        return SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 8.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding:const EdgeInsets.all(8),
                    color: Colors.yellow.withOpacity(0.5),
                    child: const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.warning),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                                "Please don't send SMS more than 3 times to avoid blocking your SIM card",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    color: Colors.orange
                                ),
                                softWrap: true
                            ),
                          )

                        ]
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                      "Please follow steps below to charge your account",
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
                      const StepWidget(step: "1",label: "Choose your SIM"),
                      const SizedBox(height: 10),
                      simCards.isEmpty ?
                      const Center(
                         child: Row(
                           children: [
                             Icon(
                                 Icons.sim_card_alert_outlined,
                                 color: Colors.grey
                             ),
                             Text(
                               "No SIM found",
                               style: TextStyle(
                                 color: Colors.grey
                               ),
                             ),
                           ],
                         )
                       )
                      :Row(
                        children: simCards.map<Widget>(
                                (elm)=>SimCardWidget(
                                    simCard: elm,
                                    onTap:()async{
                                      bool canContinue = true;
                                      ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
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
                                      isProcessing = false;
                                      if(!isStepVisible(2)) showStep(2);
                                      else{
                                        hideStep(3);
                                        hideStep(4);
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
                                            showStep(3);
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: ButtonWidget(
                                icon: Icons.edit,
                                text: "Type",
                                onPressed: () => _openDialogForCode(),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ButtonWidget(
                                icon: Icons.camera,
                                text: "Scan",
                                onPressed: (){
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>AlertDialog(
                                          content: ScanAlertContentWidget(
                                              codeLength:selectedSimCard?.getCodeLength(),
                                              onDone: (BuildContext context,String text){
                                                if(scannedCode is String && scannedCode!.isNotEmpty) return;
                                                Navigator.of(context).pop();
                                                _saveCode(text);
                                              }
                                          )
                                      )
                                  );
                                },
                            ),
                          )
                        ],
                      ):Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         crossAxisAlignment: CrossAxisAlignment.center,
                         children: [
                           Expanded(
                             child: Text(
                               "${isCodeValid?"":"Invalid code \n"}${scannedCode!}",
                               style: TextStyle(
                                   color: isCodeValid? Colors.green:Colors.red
                               ),
                               textAlign: TextAlign.center,
                             ),
                           ),
                           InkWell(
                               onTap: ()=>_openDialogForCode(text: scannedCode),
                               child: Container(
                                 decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(50),
                                   color: Theme.of(context).colorScheme.primary,
                                 ),
                                 padding: const EdgeInsets.all(8.0),
                                 child:const Icon(Icons.edit_note,color: Colors.white),
                               )
                           ),
                           const SizedBox(width:5),
                           InkWell(
                               onTap: ()=>refreshStep3(),
                               child: Container(
                                 decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(50),
                                   color: Theme.of(context).colorScheme.primary,
                                 ),
                                 padding: const EdgeInsets.all(8.0),
                                 child:const Icon(Icons.close_sharp,color: Colors.white),
                               )
                           )
                         ],
                       )
                    ],
                  ),
                  if(isStepVisible(4))
                  //step 4 : send sms
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      FutureBuilder(
                          future: selectedSimCard?.getOperator().getRechargeNumber(),
                          builder: (context, snapshot) => StepWidget(step: "4",label: "Send Sms ${selectedSimCard is SimCardEntity?"To ${snapshot.data}":""}"),
                      ),
                      const SizedBox(height:20),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CodeWidget(code:scannedCode!),
                            const SizedBox(width: 5),
                            OfferWidget(offer: selectedOffer!),
                            const SizedBox(width: 5),
                            SendButtonWidget(
                              isProcessing: isProcessing,
                              onTap:isProcessing? null : (){
                                isProcessing = true;
                                setState(() {});
                                ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                                if(selectedSimCard is SimCardEntity && scannedCode is String && selectedOffer is String){
                                    listenSms(true);
                                    context.read<RemoteRechargeAccountBloc>().add(
                                      RemoteRechargeAccount(
                                          RechargeEntity(
                                            code: scannedCode!, // Sample recharge code
                                            simCard: selectedSimCard!, // Selected SIM card
                                            offer: selectedOffer!, // Example offer
                                          ),
                                      ),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            duration:const Duration(minutes: 10),
                                            backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                                            content:Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                const SizedBox(
                                                    width:20,
                                                    height: 20,
                                                    child: CircularProgressIndicator(color: Colors.white,strokeWidth: 2,)
                                                ),
                                                const Spacer(),
                                                const Text("Waiting for confirmation sms ..."),
                                                const Spacer(),
                                                TextButton(
                                                    onPressed: (){
                                                      if(mounted) {
                                                        listenSms(false);
                                                        isProcessing = false;
                                                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                                      } else {
                                                          scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
                                                      }
                                                      setState(() {});
                                                    },
                                                    child: Container(
                                                      padding:const EdgeInsets.symmetric(horizontal: 4,vertical: 2),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(5),
                                                        color: Colors.white
                                                      ),
                                                      child: Text(
                                                          "Cancel",
                                                          style: TextStyle(
                                                              color: Theme.of(context).colorScheme.primary,
                                                          )
                                                      ),
                                                    )
                                                )
                                              ],
                                            )
                                        )
                                    );
                                }else{
                                  isProcessing = false;
                                  setState(() {});
                                  ScaffoldMessenger.of(context).showMaterialBanner(
                                    MaterialBanner(
                                      backgroundColor: Theme.of(context).colorScheme.error,
                                      content:Text(
                                          'Something wrong , please try later !',
                                          style: TextStyle(
                                            color: Theme.of(context).colorScheme.onError
                                          )
                                      ),
                                      leading:const Icon(Icons.error),
                                      actions: <Widget>[
                                          TextButton(
                                              onPressed: () {
                                                ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                                                if(context.canPop()) context.pop();
                                              },
                                              child:const Text("Undo")
                                          )
                                      ],
                                    ),
                                  );
                                }
                            })
                          ],
                        ),
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
