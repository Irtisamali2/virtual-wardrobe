import 'dart:io';

import 'package:flutter/material.dart';

class WardRobeProvider extends ChangeNotifier {
  String _shirtImageCamera = '';
  String get shirtImageCamera => _shirtImageCamera;
  String _shirtImageApp = '';
  String get shirtImageApp => _shirtImageApp;
  Future shirtImagePicked(
      {required String pickedImagefromApp,
      required String pickImageFromCamera}) async {
    if (pickImageFromCamera.isNotEmpty) {
      _shirtImageCamera = pickImageFromCamera;
    } else if (pickedImagefromApp.isNotEmpty) {
      _shirtImageApp = pickedImagefromApp;
    }
    notifyListeners();
  }

  String _pentImageCamera = '';
  String get pentImageCamera => _pentImageCamera;
  String _pentImageApp = '';
  String get pentImageApp => _pentImageApp;
  Future pentImagePicked(
      {required String pickedImagefromApp,
      required String pickImageFromCamera}) async {
    if (pickImageFromCamera.isNotEmpty) {
      _pentImageCamera = pickImageFromCamera;
    } else if (pickedImagefromApp.isNotEmpty) {
      _pentImageApp = pickedImagefromApp;
    }
    notifyListeners();
  }

  String _shoesImageCamera = '';
  String get shoesImageCamera => _shoesImageCamera;
  String _shoesImageApp = '';
  String get shoesImageApp => _shoesImageApp;
  Future shoesImagePicked(
      {required String pickedImagefromApp,
      required String pickImageFromCamera}) async {
    if (pickImageFromCamera.isNotEmpty) {
      _shoesImageCamera = pickImageFromCamera;
    } else if (pickedImagefromApp.isNotEmpty) {
      _shoesImageApp = pickedImagefromApp;
    }
    notifyListeners();
  }

  bool _check = false;
  bool get check => _check;
  void getCheck(bool value) {
    _check = value;
    notifyListeners();
  }
}
