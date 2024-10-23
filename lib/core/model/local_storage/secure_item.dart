import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SecItemModel {
  SecItemModel(this.key, this.value,{this.readOnly=false,this.title = "No Label",this.icon,this.description,this.isCheckbox=true});

  final String key;
  final dynamic value;
  final bool readOnly;
  final String title;
  final String? description;
  final IconData? icon;
  final bool isCheckbox;
  SecItemModel copyWith(dynamic value){
    return SecItemModel(
     key,
     value??this.value,
     readOnly: readOnly,
     title: title,
     icon:icon,
     description: description,
      isCheckbox: isCheckbox
    );
  }

  static SecItemModel? getByKey(String key,List<SecItemModel> items){
    try{
      return items.firstWhere((elm)=>elm.key==key);
    }catch(err){
      if(kDebugMode) print(err);
      return null;
    }
  }

}