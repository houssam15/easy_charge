import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:recharge_by_scan/core/util/local_storage.dart';
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
    LocalStorage.DISABLE_SKIP_ONBOARD_PAGE
  ];
  Future<List<SecItemModel>>? _future;
  List<SecItemModel>? _settings;
  Future<List<SecItemModel>> _getSettings() async{
    _settings = await sl.get<LocalStorage>().get(_SETTINGS);
    return _settings!;
  }

  _toggle(SecItemModel elm,bool newValue)async{
      await sl.get<LocalStorage>().add(
          [elm.copyWith(newValue==true?LocalStorage.TRUE:LocalStorage.FALSE)]
      );
      _settings =await sl.get<LocalStorage>().get(_SETTINGS);
      setState(() {});
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
          return const CircularProgressIndicator();
        }else if(snapshot.data is! List<SecItemModel>) {
          return const Center(child: Text("No Settings" ,textAlign: TextAlign.center));
        }else{
            return SettingsList(
                sections: [
                  SettingsSection(
                    title: const Text('Common'),
                    tiles:_settings!.map((elm)=> SettingsTile.switchTile(
                      leading: elm.icon is! IconData?null:Icon(elm.icon),
                      title: Column(
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
                      ),
                      onToggle:(value)=> _toggle(elm,value),
                      initialValue: elm.value==LocalStorage.TRUE,
                    )).toList(),
                  )
                ]
            );
          }
        }
    );
  }
}
