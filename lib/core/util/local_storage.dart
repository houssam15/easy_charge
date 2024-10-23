import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../model/model.dart';

class LocalStorage{

    final _storage = const FlutterSecureStorage();
    static String IS_INITIALIZED = "is_initialized";
    static String IS_ONBOARD_PASSED = "is_onboard_passed";
    static String DISABLE_SKIP_ONBOARD_PAGE = "disable_skip_onboard_page";
    static String MAROC_TELECOM_SMS_NUMBER = "maroc_telecom_sms_number";
    static String ORANGE_SMS_NUMBER = "orange_sms_number";
    static String INWI_SMS_NUMBER = "inwi_sms_number";
    static String TRUE = "Y";
    static String FALSE = "N";

    final List<String> authorizedSettings = [IS_INITIALIZED,IS_ONBOARD_PASSED,DISABLE_SKIP_ONBOARD_PAGE,MAROC_TELECOM_SMS_NUMBER,ORANGE_SMS_NUMBER,INWI_SMS_NUMBER];

    final List<SecItemModel> defaultLocalVariables = [
      SecItemModel(IS_INITIALIZED, TRUE,readOnly: true),
      SecItemModel(IS_ONBOARD_PASSED, FALSE),
      SecItemModel(DISABLE_SKIP_ONBOARD_PAGE, FALSE,icon: Icons.developer_board,title: "Show tutorial",description: "if you enable it you will always see tutorials (not recommended)"),
      SecItemModel(MAROC_TELECOM_SMS_NUMBER, "555",icon: Icons.sms,title: "Maroc telecom",isCheckbox: false),
      SecItemModel(ORANGE_SMS_NUMBER, "555",icon: Icons.sms,title: "Orange",isCheckbox: false),
      SecItemModel(INWI_SMS_NUMBER, "121",icon: Icons.sms,title: "Inwi",isCheckbox: false)
    ];

    AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
        sharedPreferencesName: 'Settings',
        preferencesKeyPrefix: 'Setting'
    );

    Future<bool> _isInitialized()async{
      return await _storage.containsKey(
          key: IS_INITIALIZED,
          aOptions: _getAndroidOptions()
      );
    }

    List<SecItemModel> _validate(List<SecItemModel> params,{bool ignoreReadOnly=false}){
      return params
          .where((elm)=>authorizedSettings.contains(elm.key)==true && (elm.readOnly==false || ignoreReadOnly))
          .map((elm)=>SecItemModel(elm.key, elm.value))
          .toList();
    }

    Future<LocalStorage> initialize({bool force = false}) async{
      try{
        if(await _isInitialized() == false || force) await add(defaultLocalVariables,ignoreReadOnly: true);
      }catch(err){
        if(kDebugMode) print(err);
      }
      return this;
    }

    Future<List<SecItemModel>> get(List<String> keys) async{
      List<SecItemModel> r = [];
      for(String key in keys){
        SecItemModel? item = SecItemModel.getByKey(key, defaultLocalVariables);
        if(item is! SecItemModel) continue;
        r.add(item.copyWith(
            await _storage.read(key: key,aOptions: _getAndroidOptions())
        ));
      }
      return r;
    }

    Future<SecItemModel?> getOne(String key) async{
      SecItemModel? item = SecItemModel.getByKey(key, defaultLocalVariables);
      if(item is! SecItemModel) return null;
      return item.copyWith(
          await _storage.read(key: key, aOptions: _getAndroidOptions())
      );
    }

    add(List<SecItemModel> params,{bool ignoreReadOnly = false})async{
      for(SecItemModel item in _validate(params,ignoreReadOnly: ignoreReadOnly)){
        await _storage.write(
            key: item.key,
            value: item.value,
            aOptions: _getAndroidOptions()
        );
      }
    }

    delete(List<SecItemModel> params,{bool ignoreReadOnly = false}) async{
      _validate(params,ignoreReadOnly: ignoreReadOnly).map((elm) async{
        await _storage.delete(
          key: elm.key,
          aOptions: _getAndroidOptions()
        );
      });
    }

}

