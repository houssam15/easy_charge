import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:go_router/go_router.dart';
import 'package:recharge_by_scan/config/routes/routes.dart';
import 'package:recharge_by_scan/core/util/local_storage.dart';
import 'package:recharge_by_scan/core/widgets/my_text_field.dart';
import 'package:settings_ui/settings_ui.dart';

import '../../injection_container.dart';
import '../model/local_storage/secure_item.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final List<String> _SETTINGS = [
    LocalStorage.DISABLE_SKIP_ONBOARD_PAGE,
    LocalStorage.MAROC_TELECOM_SMS_NUMBER,
    LocalStorage.ORANGE_SMS_NUMBER,
    LocalStorage.INWI_SMS_NUMBER
  ];
  Future<List<SecItemModel>>? _future;
  List<SecItemModel>? _settings;
  Future<List<SecItemModel>> _getSettings() async{
    _settings = await sl.get<LocalStorage>().get(_SETTINGS);
    return _settings!;
  }

  _toggle(SecItemModel elm,bool newValue) async => await _save(elm, newValue);

  _change(SecItemModel elm){
    TextEditingController controller = TextEditingController(text: elm.value);
      return AlertDialog(
        title: Text(elm.title),
        content: MyTextField(controller),
        actions: [
          TextButton(onPressed: ()=>context.pop(), child:const Text("Cancel")),
          TextButton(onPressed: ()async{
            await _save(elm,controller.value.text);
            context.pop();
          }, child:const Text("Save"))
        ],
      );
  }

  _save(SecItemModel elm,dynamic newValue)async{
    try{
      await sl.get<LocalStorage>().add(
          [
            elm.copyWith(elm.isCheckbox==false
                ?newValue
                :newValue==true?LocalStorage.TRUE:LocalStorage.FALSE)
          ]
      );
      _settings =await sl.get<LocalStorage>().get(_SETTINGS);
      setState(() {});
    }catch(err){
      if(kDebugMode) print(err);
    }
  }

  _buildTitle(SecItemModel elm){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(elm.title,style:const TextStyle(fontSize: 16,fontWeight: FontWeight.w500)),
        SizedBox(height: elm.description is String?5:null),
        if(elm.description is String)
          Text(
              elm.description!,
              style:const TextStyle(fontSize: 10,fontWeight: FontWeight.w400,color: Colors.grey)
          )
      ],
    );
  }

  @override
  void initState() {
    _future = _getSettings();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildSettings(),
    );
  }

  _buildSettings(){
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot){
        if(snapshot.connectionState==ConnectionState.waiting){
          return const Center(child:  CircularProgressIndicator());
        }else if(snapshot.data is! List<SecItemModel>) {
          return const Center(child: Text("No Settings" ,textAlign: TextAlign.center));
        }else{
            return SettingsList(
                sections: [
                  SettingsSection(
                    title: const Text('Common'),
                    tiles:_settings!.map((elm)=>
                      elm.isCheckbox?
                      SettingsTile.switchTile(
                          leading: elm.icon is! IconData?null:Icon(elm.icon),
                          title: _buildTitle(elm),
                          onToggle:(value)=> _toggle(elm,value),
                          initialValue: elm.value==LocalStorage.TRUE,
                      ):
                      SettingsTile.navigation(
                          leading: elm.icon is! IconData?null:Icon(elm.icon),
                          title: _buildTitle(elm),
                          onPressed: (context) {
                              showDialog(context: context, builder: (context) => _change(elm));
                          },
                          trailing: Row(
                            children: [
                              Text(elm.value??"",style:const TextStyle(fontWeight: FontWeight.w500,color: Colors.grey)),
                              const SizedBox(width: 5),
                              const Icon(Icons.chevron_right,color: Colors.grey)
                            ],
                          ),
                      )
                    ).toList()

                  )
                ]
            );
          }
        }
    );
  }
}
