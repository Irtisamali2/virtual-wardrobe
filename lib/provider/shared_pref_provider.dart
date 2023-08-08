import 'dart:async';
import 'dart:convert';
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

    final encodeUrls = url.map((e) => base64Encode(utf8.encode(e))).toList();
    await prefs.setStringList(category, encodeUrls);
    // var encodeData = dataModelToJson(DataModel(
    //   category: category,
    //   url: url,
    // ));
    // await prefs.setString(key, encodeData);
    // print('add');
    notifyListeners();
  }

  Future<List<String>> getSharedPrefList(String category) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final encodedUrl = prefs.getStringList(category);
    final urls = encodedUrl?.map((e) => utf8.decode(base64Decode(e))).toList();
    return urls ?? [];
  }

  List<String> _imageUrlsSharedPref = [];
  List<String> get imageUrlSharedPref => _imageUrlsSharedPref;
  Future<void> loadImageUrls(String category) async {
    final loadUrl = await getSharedPrefList(category);
    _imageUrlsSharedPref = loadUrl;
    notifyListeners();
  }

  bool _hasData = false;
  bool get hasData => _hasData;
  void getData() {
    Timer(const Duration(seconds: 5), () {
      _hasData = true;
      print(_hasData);
      notifyListeners();
    });
    // notifyListeners();
  }

  // String _imageUrl = '';
  // String get imageUrl => _imageUrl;
  // Future getPrefData(int index) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var data = await prefs.getString('Shirt');
  //   final DataModel model = dataModelFromJson(data ?? '');
  //   print(model.url!.length);

  //   if (model.url != null) {
  //     for (int i = 0; i < model.url!.length; i++) {
  //       http.Response imagefil = await http.get(Uri.parse(model.url![i]));
  //       Uint8List imageBytes = imagefil.bodyBytes;
  //       String base64String = base64.encode(imageBytes);
  //       _imageUrl = base64String;
  //     }
  //     _uniList = base64Decode(imageUrl);
  //   }
  //   print(uniList);

  //   notifyListeners();
  // }

  // String _email = '';
  // String get email => _email;
  // void getEmail() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //    _email = prefs.getString('email') ?? '';

  //   notifyListeners();
  // }
}
