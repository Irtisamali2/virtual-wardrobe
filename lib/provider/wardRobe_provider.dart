import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

class WardRobeProvider extends ChangeNotifier {
  String _shirtImageCamera = '';
  String get shirtImageCamera => _shirtImageCamera;
  String _shirtImageApp = '';
  String get shirtImageApp => _shirtImageApp;
  Future shirtImagePicked(
      {required String pickedImagefromApp,
      required String pickImageFromCamera}) async {
    if (pickImageFromCamera.isNotEmpty) {
      shirtImageCrop(pickImageFromCamera);
    } else if (pickedImagefromApp.isNotEmpty) {
      _shoesImageApp = pickedImagefromApp;
    }
    notifyListeners();
  }

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

  String _pentImageCamera = '';
  String get pentImageCamera => _pentImageCamera;
  String _pentImageApp = '';
  String get pentImageApp => _pentImageApp;
  Future pentImagePicked(
      {required String pickedImagefromApp,
      required String pickImageFromCamera}) async {
    if (pickImageFromCamera.isNotEmpty) {
      pentImageCrop(pickImageFromCamera);
    } else if (pickedImagefromApp.isNotEmpty) {
      _pentImageApp = pickedImagefromApp;
    }
    notifyListeners();
  }

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

  String _shoesImageCamera = '';
  String get shoesImageCamera => _shoesImageCamera;
  String _shoesImageApp = '';
  String get shoesImageApp => _shoesImageApp;
  Future shoesImagePicked(
      {required String pickedImagefromApp,
      required String pickImageFromCamera}) async {
    if (pickImageFromCamera.isNotEmpty) {
      shoesImageCrop(pickImageFromCamera);
    } else if (pickedImagefromApp.isNotEmpty) {
      _shoesImageApp = pickedImagefromApp;
    }
    notifyListeners();
  }

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

  bool _check = false;
  bool get check => _check;
  void getCheck(bool value) {
    _check = value;
    notifyListeners();
  }
}
