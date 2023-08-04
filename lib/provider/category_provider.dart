import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SelectCategory extends ChangeNotifier {
  int _index = 0;
  int _categoryUploadImageIndex = -1;

  String _category = '';
  String get getNewCategory => _category;
  int get selectedIndex => _index;
  int get categoryUploadImageIndex => _categoryUploadImageIndex;

  void categoryImageUpload(int index) {
    _categoryUploadImageIndex = index;
    notifyListeners();
  }

  void selctIndex(int index) {
    _index = index;
    notifyListeners();
  }

  void selectCategory(String category) {
    _category = category;
    notifyListeners();
  }

  String _cameraImage = '';
  String get cameraImage => _cameraImage;
  Future imagePicked(String pickedImage) async {
    if (pickedImage != null) {
      _cameraImage = pickedImage;
    }
    notifyListeners();
  }
}
