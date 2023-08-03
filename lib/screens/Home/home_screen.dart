import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../provider/category_selected.dart';
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
        .getImageFromSource(source: ImageSource.camera)
        .whenComplete(() => {setState(() {})});
    if (pickedImage != null) {
      setState(() {
        _profileImage = pickedImage.path;
      });
    }
  }

  String? newValue;
  int selectedIndex = 0;
  final _auth = FirebaseAuth.instance.currentUser!.uid;

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final TextEditingController _newCategoryController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final _changeIndex = Provider.of<SelectCategory>(context);
    final currentIndex = _changeIndex.selectedIndex;
    return Scaffold(
        key: _key,
        drawer: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection(_auth).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              } else {
                final List<dynamic> category =
                    snapshot.data!.docs.map((doc) => doc.id).toList();
                return drawer(
                    category: category,
                    addImageTofireBase: () {
                      uplaodImage(
                              File(_profileImage), context, newValue.toString())
                          .then((value) {
                        setState(() {
                          _profileImage = '';
                        });
                      });
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
                    });
              }
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
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection(_auth).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  final data = snapshot.data;
                  return ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                              onTap: () {
                                print(data!.docs[1]['url'] as List<dynamic>);
                                _key.currentState!.openDrawer();
                              },
                              child: Icon(Icons.menu)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: List.generate(
                              data!.docs.length,
                              (index) => GestureDetector(
                                    onTap: () {
                                      _changeIndex.selctIndex(index);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: currentIndex == index
                                              ? Colors.black26
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      margin: const EdgeInsets.all(5),
                                      padding: const EdgeInsets.all(20),
                                      child: Center(
                                        child: Text(
                                          data.docs[index]['category'],
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: currentIndex == index
                                                  ? Colors.white
                                                  : Colors.black54),
                                        ),
                                      ),
                                    ),
                                  )),
                        ),
                      ),
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: data.docs[selectedIndex]['url'].length,
                            itemBuilder: (context, index) {
                              var image = data.docs[selectedIndex]['url'];
                              if (image[index] == null) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                return Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.network(
                                        image[index],
                                        height: 200,
                                        width: 200,
                                        fit: BoxFit.cover,
                                      )),
                                );
                              }
                            }),
                      )
                    ],
                  );
                }
              }),
        ));
  }
}

Future<void> createCategory(
    TextEditingController category, BuildContext context) {
  var uid = FirebaseAuth.instance.currentUser!.uid;

  return FirebaseFirestore.instance.collection(uid).doc(category.text).set(
      {'category': category.text}).then((value) => Navigator.of(context).pop());
}

Future<void> uplaodImage(
    File file, BuildContext context, String selectedCategory) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  Reference storageRef = _storage.ref(uid).child(const Uuid().v4());
  await storageRef.putFile(file);
  String imageUrl = await storageRef.getDownloadURL();

  String documentId = uid;
  List<String> data = [
    imageUrl,
  ];
  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection(documentId);
  await collectionReference.doc(selectedCategory).update(
      {'url': FieldValue.arrayUnion(data)}).then((value) => print(true));
}
