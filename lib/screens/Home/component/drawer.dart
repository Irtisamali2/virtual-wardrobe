import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_signin/reusable_widgets/reusable_widget.dart';
import 'package:firebase_signin/screens/signin_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../provider/category_provider.dart';
import '../../../utils/color_utils.dart';
import 'create_category_bottom_sheet.dart';

Widget drawer(
    {required BuildContext context,
    required String url,
    required List category,
    required Function addImageTofireBase,
    required Function pickImage,
    required TextEditingController controller,
    required addCategoryFunction}) {
  return Drawer(
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 50),
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        hexStringToColor("CB2B93"),
        hexStringToColor("9546C4"),
        hexStringToColor("5E61F4")
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: Column(
        // Important: Remove any padding from the ListView.

        children: [
          ListTile(
            leading: Icon(
              Icons.photo,
              color: Colors.white,
            ),
            title: const Text('Add New Picture',
                style: TextStyle(color: Colors.white, fontSize: 20)),
            onTap: () {
              Navigator.pop(context);
              showBottomSheetForImagePicker(
                  category: category,
                  addImageTofireBase: addImageTofireBase,
                  context: context,
                  imageUrl: url,
                  onTap: pickImage);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.category,
              color: Colors.white,
            ),
            title: const Text('New Category',
                style: TextStyle(color: Colors.white, fontSize: 20)),
            onTap: () {
              Navigator.pop(context);
              createCategoryBottomSheet(
                context,
                controller,
                addCategoryFunction,
              );
            },
          ),
          const Spacer(),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
            ),
            title: const Text('Log out'),
            onTap: () {
              FirebaseAuth.instance.signOut().then((_) {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const SignInScreen(),
                ));
                print('logout');
              });
            },
          ),
        ],
      ),
    ),
  );
}

showBottomSheetForImagePicker(
    {required BuildContext context,
    required String imageUrl,
    required List category,
    required Function addImageTofireBase,
    required Function onTap}) {
  return showModalBottomSheet(
    context: context,
    builder: (context) {
      final _changeIndex = Provider.of<SelectCategory>(context);
      final currentIndex = _changeIndex.selectedIndex;
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          hexStringToColor("CB2B93"),
          hexStringToColor("9546C4"),
          hexStringToColor("5E61F4")
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Category',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Wrap(
              spacing: 10,
              children: List.generate(
                  category.length,
                  (index) => GestureDetector(
                        onTap: () {
                          _changeIndex.selctIndex(index);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: currentIndex == index
                                  ? Colors.black26
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.all(20),
                          child: Text(category[index].toString(),
                              style: TextStyle(
                                  fontSize: 20,
                                  color: currentIndex == index
                                      ? Colors.white
                                      : Colors.black54)),
                        ),
                      )),
            ),
           const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                onTap();
              },
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.30,
                width: double.infinity,
                child: imageUrl == ''
                    ? const Center(
                        child: Text('Pick An Image'),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.file(
                          File(imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            firebaseUIButton(context, 'Add', addImageTofireBase)
          ],
        ),
      );
    },
  );
}
