import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../bloc/remote/recharge_account/remote_recharge_account_bloc.dart";
import "../bloc/remote/recharge_account/remote_recharge_account_event.dart";

class ListenIncomingSms extends StatefulWidget {
  final bool isActive;
  final bool isError;

  const ListenIncomingSms({super.key,required this.isActive,required this.isError});

  @override
  State<ListenIncomingSms> createState() => _ListenIncomingSmsState();
}

class _ListenIncomingSmsState extends State<ListenIncomingSms> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin:const EdgeInsets.symmetric(vertical: 16,horizontal: 8),
      child: Row(
        children: [
          const Expanded(flex:9,child: Text("Listen state :")),
          Expanded(
              flex: 3,
              child:GestureDetector(
                  onTap: () {
                    context.read<RemoteRechargeAccountBloc>().add(RemoteRechargeAccountListenSms(widget.isActive!=true));
                  },
                  child: widget.isError==true?
                          const Text("Error happen",style: TextStyle(color: Colors.red))
                         :Text(widget.isActive==true?'active':"inactive",style:TextStyle(color:widget.isActive==true? Colors.green:Colors.grey)),
              )
          )
        ],
      ),
    );
  }
}
