import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

class WardRobeProvider extends ChangeNotifier {
  //for shirt Image from Camera
  String _shirtImageCamera = '';
  String get shirtImageCamera => _shirtImageCamera;
  //for shirt Image from App
  String _shirtImageApp = '';
  String get shirtImageApp => _shirtImageApp;
  Future shirtImagePicked(
      {required String pickedImagefromApp,
      required String pickImageFromCamera}) async {
    if (pickImageFromCamera.isNotEmpty) {
      shirtImageCrop(pickImageFromCamera);
    } else if (pickedImagefromApp.isNotEmpty) {
      _shirtImageApp = pickedImagefromApp;
      _shirtImageCamera = '';
    }
    notifyListeners();
  }
//for shirt Crop
  void shirtImageCrop(String filePath) async {
    final croppedImage = await ImageCropper().cropImage(
      sourcePath: filePath,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
            // toolbarTitle: 'Cropper',
            toolbarColor: Colors.transparent,
            toolbarWidgetColor: Colors.black,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedImage != null) {
      _shirtImageCamera = croppedImage.path;
      notifyListeners();
    }
    notifyListeners();
  }
//for Pent Image From Camera
  String _pentImageCamera = '';
  String get pentImageCamera => _pentImageCamera;
  //For Pent Image From App
  String _pentImageApp = '';
  String get pentImageApp => _pentImageApp;
  Future pentImagePicked(
      {required String pickedImagefromApp,
      required String pickImageFromCamera}) async {
    if (pickImageFromCamera.isNotEmpty) {
      pentImageCrop(pickImageFromCamera);
    } else if (pickedImagefromApp.isNotEmpty) {
      _pentImageApp = pickedImagefromApp;
      _pentImageCamera = '';
    }
    notifyListeners();
  }
//Crop Pent Image 
  void pentImageCrop(String filePath) async {
    final croppedImage = await ImageCropper().cropImage(
      sourcePath: filePath,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
            // toolbarTitle: 'Cropper',
            toolbarColor: Colors.transparent,
            toolbarWidgetColor: Colors.black,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedImage != null) {
      _pentImageCamera = croppedImage.path;
      notifyListeners();
    }
    notifyListeners();
  }
// For Shoes Image From Camera
  String _shoesImageCamera = '';
  String get shoesImageCamera => _shoesImageCamera;
//For Shoes Image From App
  String _shoesImageApp = '';
  String get shoesImageApp => _shoesImageApp;
  
  Future shoesImagePicked(
      {required String pickedImagefromApp,
      required String pickImageFromCamera}) async {
    if (pickImageFromCamera.isNotEmpty) {
      shoesImageCrop(pickImageFromCamera);
    } else if (pickedImagefromApp.isNotEmpty) {
      _shoesImageApp = pickedImagefromApp;
      _shoesImageCamera = '';
    }
    notifyListeners();
  }
  // Crop Shoes Image

  void shoesImageCrop(String filePath) async {
    final croppedImage = await ImageCropper().cropImage(
      sourcePath: filePath,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
            // toolbarTitle: 'Cropper',
            toolbarColor: Colors.transparent,
            toolbarWidgetColor: Colors.black,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedImage != null) {
      _shoesImageCamera = croppedImage.path;
      notifyListeners();
    }
    notifyListeners();
  }
// using Function For Hide and Show Drawer Button When Overaly Open
  bool _check = false;
  bool get check => _check;
  void getCheck(bool value) {
    _check = value;
    notifyListeners();
  }
}
