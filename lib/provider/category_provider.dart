import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:image_cropper/image_cropper.dart';

import '../screens/Home/home_screen.dart';
import '../utils/loader/loading_screen.dart';

class SelectCategory extends ChangeNotifier {

  int _index = 0;
  int get selectedIndex => _index;
  //index for using category selection to upload Image
  int _categoryUploadImageIndex = -1;
  int get categoryUploadImageIndex => _categoryUploadImageIndex;
  
//for getting selected Category Value
  String _category = '';
  String get getNewCategory => _category;

  
  
  //for drawer Buttons Index
  int _drawerIndex = -1;
  int get drawerIndex => _drawerIndex;

  //function for getting selected Drawer Button Index
  void getDrawerIndex(int index) {
    _drawerIndex = index;
    notifyListeners();
  }
//function for gettting index of selected Category
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

//for path of the image picked by camera to upload
  String _cameraImage = '';
  String get cameraImage => _cameraImage;

//function for pickinng image using Camera to upload
  Future imagePicked() async {
    var pickedImage = await ImagePicker.platform
        .getImageFromSource(source: ImageSource.camera);
    if (pickedImage != null) {
      cropImage(pickedImage.path);
      notifyListeners();
    }
    notifyListeners();
  }

//function for Cropp picked image before upload
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

//function for Upload Image to FireStorage and save path to cloud firestore
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
