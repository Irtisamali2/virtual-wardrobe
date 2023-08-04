import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_signin/provider/category_provider.dart';
import 'package:firebase_signin/reusable_widgets/reusable_widget.dart';
import 'package:firebase_signin/screens/Home/component/upload_image_bottom_sheet.dart';
import 'package:firebase_signin/screens/signin_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../utils/color_utils.dart';
import 'create_category_bottom_sheet.dart';

Widget drawer(
    {required BuildContext context,
    required List category,
    required Function addImageTofireBase,
    required Function pickImage,
    required TextEditingController controller,
    required addCategoryFunction}) {
  return Drawer(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
      topRight: Radius.circular(20),
      bottomRight: Radius.circular(20),
    )),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 50),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          gradient: LinearGradient(colors: [
            hexStringToColor("CB2B93"),
            hexStringToColor("9546C4"),
            hexStringToColor("5E61F4")
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: Column(
        // Important: Remove any padding from the ListView.

        children: [
          ListTile(
            leading: const Icon(
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
                  onTap: pickImage);
            },
          ),
          const SizedBox(
            height: 10,
          ),
          ListTile(
            leading: const Icon(
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
            leading: const Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            title: const Text('Log out',
                style: TextStyle(color: Colors.white, fontSize: 20)),
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
