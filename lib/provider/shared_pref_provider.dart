import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/data_models.dart';
import 'package:http/http.dart' as http;

class SharedPrefProvider extends ChangeNotifier {
  Future setSharedPref(
      {required String category,
      required List<dynamic> url,
      required String key}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var encodeData = dataModelToJson(DataModel(
      category: category,
      url: url,
    ));
    await prefs.setString(key, encodeData);
    print('add');
    notifyListeners();
  }

  String _imageUrl = '';
  String get imageUrl => _imageUrl;
  Uint8List? _uniList;
  Uint8List get uniList => _uniList!;
  
  Future getPrefData(int index) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
     var data = await prefs.getString('Shirt');
    if(data!=null)
    try{
    
    final DataModel model = dataModelFromJson(data ?? '');
    print(model.url!.length);

    if (model.url != null) {
      for (int i = 0; i < model.url!.length; i++) {
        http.Response imagefil = await http.get(Uri.parse(model.url![i]));
        Uint8List imageBytes = imagefil.bodyBytes;
        String base64String = base64.encode(imageBytes);
        _imageUrl = base64String;
      }
      _uniList = base64Decode(imageUrl);
    }
    print(uniList);

    notifyListeners();
    }catch(e){

    }
   
  }

  // String _email = '';
  // String get email => _email;
  // void getEmail() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //    _email = prefs.getString('email') ?? '';
    
  //   notifyListeners();
  // }
}
