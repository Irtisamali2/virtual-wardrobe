import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../utils/color_utils.dart';
import 'component/drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _profileImage = '';

  Future imagePicked() async {
    final pickedImage = await ImagePicker.platform
        .getImageFromSource(source: ImageSource.camera).whenComplete(()=> {setState((){})});
    if (pickedImage != null) {
      setState(() {
        _profileImage = pickedImage.path;
      });
    }
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final TextEditingController _newCategoryController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        drawer: drawer(
            addImageTofireBase: () {
              uplaodImage(File(_profileImage), context);
            },
            pickImage: () {
              imagePicked();
              print(_profileImage);
            },
            url: _profileImage,
            context: context,
            controller: _newCategoryController,
            addCategoryFunction: () {
              createCategory(_newCategoryController, context);
              // var uid = FirebaseAuth.instance.currentUser!.uid;
              print('uid');
            }),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            hexStringToColor("CB2B93"),
            hexStringToColor("9546C4"),
            hexStringToColor("5E61F4")
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                      onTap: () {
                        _key.currentState!.openDrawer();
                      },
                      child: Icon(Icons.menu)),
                ),
              )
            ],
          ),
        ));
  }
}

Future createCategory(TextEditingController category, BuildContext context) {
  var uid = FirebaseAuth.instance.currentUser!.uid;
  return FirebaseFirestore.instance.collection(uid).doc(uid).update({
    'category': category.text,
  }).then((value) => Navigator.of(context).pop());
}

Future<void> uplaodImage(File file, BuildContext context) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  Reference storageRef = _storage.ref(uid).child(const Uuid().v4());
  await storageRef.putFile(file);
  String imageUrl = await storageRef.getDownloadURL();

  String documentId = uid;
  Map<String, dynamic> data = {
    "image_url": imageUrl,
  };
  _firestore
      .collection(documentId)
      .doc(documentId)
      .set(data)
      .then((value) => Navigator.of(context).pop());
}
