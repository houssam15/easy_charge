import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:recharge_by_scan/core/resources/data_state.dart";
import "package:recharge_by_scan/features/recharge_by_scan/domain/entities/sim_card.dart";
import "package:recharge_by_scan/features/recharge_by_scan/domain/entities/sms.dart";
import "package:recharge_by_scan/features/recharge_by_scan/presentation/bloc/remote/recharge_account/remote_recharge_account_bloc.dart";
import "package:recharge_by_scan/features/recharge_by_scan/presentation/bloc/remote/recharge_account/remote_recharge_account_event.dart";
import "package:recharge_by_scan/features/recharge_by_scan/presentation/bloc/remote/recharge_account/remote_recharge_account_state.dart";
import "package:recharge_by_scan/features/recharge_by_scan/presentation/widgets/received_sms.dart";

import "../../widgets/listen_incoming_sms.dart";
import "../../widgets/recharge_button.dart";
import "../../widgets/scan_button.dart";
import "../../widgets/sim_card_list_widget.dart";

class RechargeAccountScreen extends StatefulWidget{
  const RechargeAccountScreen({super.key});

  @override
  State<RechargeAccountScreen> createState() => _RechargeAccountScreenState();
}

class _RechargeAccountScreenState extends State<RechargeAccountScreen> {
  SimCardEntity? selectedSimCard;
  List<SimCardEntity> simCards = [];
  String? scannedText;
  bool? isActive ;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void _onSimCardSelected(SimCardEntity simCard) {
    setState(() {
      selectedSimCard = simCard;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppbar(),
      body:_buildBody(),
    );
  }

  _buildAppbar(){
    return AppBar(
      title: const Text(
        'Recharge Account',
        style: TextStyle(
          color: Colors.black
        ),
      ),
    );
  }

  _buildBody(){
    return BlocConsumer<RemoteRechargeAccountBloc,RemoteRechargeAccountState>(
      listener: (context,state){
        if (state is RemoteRechargeAccountLoading) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Loading...'),
              duration: Duration(days: 1),
            ),
          );
        }
        // Remove the SnackBar when loading is complete
        if (state is! RemoteRechargeAccountLoading) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        }

        if(state is RemoteRechargeAccountInitialState){
          simCards = state.data;
          //RemoteRechargeAccountInitial
          context.read<RemoteRechargeAccountBloc>().add(const RemoteRechargeAccountListenSms(true));
        }

        if(state is RemoteRechargeAccountListeningStatus){
          isActive = state.data;
        }
      },
      builder:(context,state){
        return Center(
          child: Column(
            children: [
              ListenIncomingSms(
                  isActive:isActive??false,
                  isError:state is RemoteRechargeAccountListeningStatus && state.error != null
              ),

              SimCardsList(
                  simCards: simCards,
                  selectedSimCard:selectedSimCard,
                  onSimCardSelected:_onSimCardSelected
              ),
              if (selectedSimCard != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(flex:6,child:Text("Selected SIM: ${selectedSimCard!.name}")),
                      if(scannedText ==null)
                        Expanded(flex:6,child: ScanButton(selectedSimCard: selectedSimCard))
                      else
                        Expanded(flex:6,child: RechargeButton(selectedSimCard: selectedSimCard))
                    ],
                  ),
                ),
              if(state is RemoteRechargeAccountNewSmsReceivedStatus)
              ReceivedSms(sms: state.data!)
            
            ],
          )
        );
      }
    );
  }
}