import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/category_provider.dart';
import '../../../reusable_widgets/reusable_widget.dart';
import '../../../utils/color_utils.dart';
import '../../../utils/loader/loading_screen.dart';

showBottomSheetForImagePicker(
    {required BuildContext context,
    required List category,
    required Function addImageTofireBase,
    required Function onTap}) {
  return showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) {
      final _provider = Provider.of<SelectCategory>(context);
      final currentIndex = _provider.categoryUploadImageIndex;
      final selectCategory = _provider.getNewCategory;
      final _pickImage = _provider.cameraImage;
      return Container(
        // padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            gradient: LinearGradient(colors: [
              hexStringToColor("CB2B93"),
              hexStringToColor("9546C4"),
              hexStringToColor("5E61F4")
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            const Align(
              alignment: Alignment.center,
              child: Text(
                'Select Category',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 50,
              child: category.isEmpty
                  ? const SizedBox.shrink()
                  : ListView(
                      scrollDirection: Axis.horizontal,
                      children: List.generate(
                        category.length,
                        (index) => GestureDetector(
                          onTap: () {
                            _provider.categoryImageUpload(index);
                            _provider.selectCategory(category[index]);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 50,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                color: currentIndex == index
                                    ? Colors.black26
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(20)),
                            padding: const EdgeInsets.all(10),
                            child: Text(category[index].toString(),
                                style: TextStyle(
                                    fontSize: 20,
                                    color: currentIndex == index
                                        ? Colors.white
                                        : Colors.black54)),
                          ),
                        ),
                        growable: true,
                      ),
                    ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      onTap();
                    },
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.30,
                      width: double.infinity,
                      child: _pickImage == ''
                          ? const Center(
                              child: Text('Pick An Image'),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.file(
                                File(_pickImage),
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  firebaseUIButton(
                    context,
                    'Add',
                    () {
                      addImageTofireBase();
                      Navigator.pop(context);
                      if (_provider.cameraImage.isNotEmpty &&
                          selectCategory.isNotEmpty) {
                        LoadingScreen.inatance()
                            .show(context: context, text: 'Uploading...');
                      }
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      );
    },
  );
}
