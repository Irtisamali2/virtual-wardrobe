import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:image_cropper/image_cropper.dart';

import '../screens/Home/home_screen.dart';
import '../utils/loader/loading_screen.dart';

class SelectCategory extends ChangeNotifier {
  int _index = 0;
  int _categoryUploadImageIndex = -1;
  int _drawerIndex = -1;

  String _category = '';
  String get getNewCategory => _category;
  int get selectedIndex => _index;
  int get categoryUploadImageIndex => _categoryUploadImageIndex;
  int get drawerIndex => _drawerIndex;
  void getDrawerIndex(int index) {
    _drawerIndex = index;
    notifyListeners();
  }

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
  Future imagePicked() async {
    var pickedImage = await ImagePicker.platform
        .getImageFromSource(source: ImageSource.camera);
    if (pickedImage != null) {
      cropImage(pickedImage.path);
      notifyListeners();
    }
    notifyListeners();
  }

  void cropImage(String filePath) async {
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
      _cameraImage = croppedImage.path;
      notifyListeners();
    }
    notifyListeners();
  }

  void uploadImageToFirebase(BuildContext context, String emptyImage) {
    if (_cameraImage.isNotEmpty && getNewCategory.isNotEmpty) {
     
      uplaodImage(File(_cameraImage), context, getNewCategory.toString())
          .then((value) {
        _cameraImage = emptyImage;
        LoadingScreen.inatance().hide();
        // Navigator.of(context).pop;
        notifyListeners();
      });
      notifyListeners();
    }
    notifyListeners();
  }
}
