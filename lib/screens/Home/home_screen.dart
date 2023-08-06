import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_signin/provider/wardRobe_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../provider/category_provider.dart';
import '../../utils/color_utils.dart';
import '../../utils/loader/loading_screen.dart';
import 'imagePickerOverlay/overlay.dart';
import '../Drawer/drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance.currentUser!.uid;

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final TextEditingController _newCategoryController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<SelectCategory>(context);
    final currentIndex = _provider.selectedIndex;
    final _cameraImage = _provider.cameraImage;
    final _providerWrdRobe = Provider.of<WardRobeProvider>(context);
    final shirtImageCamera = _providerWrdRobe.shirtImageCamera;
    final shirtImageApp = _providerWrdRobe.shirtImageApp;
    final pentImageCamera = _providerWrdRobe.pentImageCamera;
    final pentImageApp = _providerWrdRobe.pentImageApp;
    final shoesImageCamera = _providerWrdRobe.shoesImageCamera;
    final shoesImageApp = _providerWrdRobe.shoesImageApp;

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
                    onTap: () {
                      _key.currentState!.closeDrawer();
                    },
                    category: category,
                    addImageTofireBase: () {
                      _provider.uploadImageToFirebase(context, '');
                    },
                    pickImage: () {
                      _provider.imagePicked();
                    },
                    context: context,
                    controller: _newCategoryController,
                    addCategoryFunction: () {
                      if (_newCategoryController.text.isNotEmpty &&
                          // ignore: unrelated_type_equality_checks
                          _newCategoryController.text !=
                              category.contains(_newCategoryController.text)) {
                        createCategory(_newCategoryController.text, context);
                      }
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
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .025,
                      ),
                      _providerWrdRobe.check == true
                          ? const SizedBox.shrink()
                          : Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, bottom: 20),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: GestureDetector(
                                    onTap: () {
                                      // print(data!.docs[1]['url'] as List<dynamic>);
                                      _key.currentState!.openDrawer();
                                    },
                                    child: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white.withAlpha(150),
                                        ),
                                        child: const Icon(
                                          Icons.menu,
                                          color: Colors.white,
                                        ))),
                              ),
                            ),
                      pickImageForWardRobe(
                        context,
                        shirtImageCamera,
                        shirtImageApp,
                        () async {
                          final pickedImage = await ImagePicker.platform
                              .getImageFromSource(source: ImageSource.camera);
                          if (pickedImage != null) {
                            _providerWrdRobe.shirtImagePicked(
                                pickImageFromCamera: pickedImage.path,
                                pickedImagefromApp: '');
                          }
                          _providerWrdRobe.getCheck(false);
                          OverlayScreen.inatance().hide();
                        },
                        () {
                          _providerWrdRobe.getCheck(false);
                          OverlayScreen.inatance().hide();
                          wardRobeAppImagePicker(
                            snapshot: snapshot,
                            onTap: (image) {
                              _providerWrdRobe.shirtImagePicked(
                                  pickImageFromCamera: '',
                                  pickedImagefromApp: image);
                            },
                            context: context,
                            data: data,
                          );
                        },
                      ),
                      pickImageForWardRobe(
                        context,
                        pentImageCamera,
                        pentImageApp,
                        () async {
                          _providerWrdRobe.getCheck(false);
                          final pickedImage = await ImagePicker.platform
                              .getImageFromSource(source: ImageSource.camera);
                          if (pickedImage != null) {
                            _providerWrdRobe.pentImagePicked(
                                pickImageFromCamera: pickedImage.path,
                                pickedImagefromApp: '');
                          }
                          OverlayScreen.inatance().hide();
                        },
                        () {
                          _providerWrdRobe.getCheck(false);
                          OverlayScreen.inatance().hide();
                          wardRobeAppImagePicker(
                            snapshot: snapshot,
                            onTap: (image) {
                              _providerWrdRobe.pentImagePicked(
                                  pickImageFromCamera: '',
                                  pickedImagefromApp: image);
                            },
                            context: context,
                            data: data,
                          );
                        },
                      ),
                      pickImageForWardRobe(
                        context,
                        shoesImageCamera,
                        shoesImageApp,
                        () async {
                          _providerWrdRobe.getCheck(false);
                          final pickedImage = await ImagePicker.platform
                              .getImageFromSource(source: ImageSource.camera);
                          if (pickedImage != null) {
                            _providerWrdRobe.shoesImagePicked(
                                pickImageFromCamera: pickedImage.path,
                                pickedImagefromApp: '');
                          }
                          OverlayScreen.inatance().hide();
                        },
                        () {
                          _providerWrdRobe.getCheck(false);
                          OverlayScreen.inatance().hide();
                          wardRobeAppImagePicker(
                            snapshot: snapshot,
                            onTap: (image) {
                              _providerWrdRobe.shoesImagePicked(
                                  pickImageFromCamera: '',
                                  pickedImagefromApp: image);
                            },
                            context: context,
                            data: data,
                          );
                        },
                      ),

                      //  imageBuilder(data, _provider, currentIndex, snapshot)
                    ],
                  );
                }
              }),
        ));
  }

  GestureDetector pickImageForWardRobe(BuildContext context, String cameraImage,
      String appImage, Function pickedCameraImage, Function pickedAppImage) {
    final _providerWardRobe =
        Provider.of<WardRobeProvider>(context, listen: false);
    return GestureDetector(
        onTap: () {
          _providerWardRobe.getCheck(true);
          OverlayScreen.inatance().show(
            context: context,
            text: 'hi',
            functionForPicCameraImage: pickedCameraImage,
            functionForPickAppImage: pickedAppImage,
          );
        },
        child: appImage.isNotEmpty || cameraImage.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: cameraImage.isNotEmpty
                    ? Image.file(
                        File(cameraImage),
                        fit: BoxFit.cover,
                        height: 200,
                        // width: 100,
                      )
                    : Image.network(
                        appImage,
                        fit: BoxFit.cover,
                        height: 200,
                        // width: 100,
                      ),
              )
            : Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                height: 200,
                // width: 100,
                child: const Center(
                  child: Text('Pick Image'),
                ),
              ));
  }

  wardRobeAppImagePicker(
      {required BuildContext context,
      required QuerySnapshot<Object?>? data,
      // required int currentIndex,
      required Function(String) onTap,
      required AsyncSnapshot<QuerySnapshot<Object?>> snapshot}) {
    final _provider = Provider.of<SelectCategory>(context, listen: false);
    // final currentIndex = _provider.selectedIndex;
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
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
            child: snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 70,
                        width: double.infinity,

                        // padding: const EdgeInsets.all(20),
                        child: data!.docs.isEmpty
                            ? const SizedBox.shrink()
                            : ListView(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                scrollDirection: Axis.horizontal,
                                children: List.generate(
                                    data.docs.length,
                                    (index) => GestureDetector(
                                          onTap: () {
                                            _provider.selctIndex(index);
                                          },
                                          child: Consumer<SelectCategory>(
                                              builder: (context, value, __) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                  color: value.selectedIndex ==
                                                          index
                                                      ? Colors.black26
                                                      : Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              margin: const EdgeInsets.all(5),
                                              padding: const EdgeInsets.all(20),
                                              child: Center(
                                                child: Text(
                                                  data.docs[index]['category'],
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color:
                                                          value.selectedIndex ==
                                                                  index
                                                              ? Colors.white
                                                              : Colors.black54),
                                                ),
                                              ),
                                            );
                                          }),
                                        ),
                                    growable: true),
                              ),
                      ),
                      data.docs.isEmpty
                          ? const SizedBox.shrink()
                          : SizedBox(
                              height: 200,
                              child: data.docs.isNotEmpty
                                  ? Consumer<SelectCategory>(
                                      builder: (context, value, __) {
                                      return ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: data
                                              .docs[value.selectedIndex]['url']
                                              .length,
                                          itemBuilder: (context, index) {
                                            var image =
                                                data.docs[value.selectedIndex]
                                                    ['url'];
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            } else {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    onTap(image[index]);
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      child: Image.network(
                                                        image[index],
                                                        height: 200,
                                                        width: 200,
                                                        fit: BoxFit.cover,
                                                      )),
                                                ),
                                              );
                                            }
                                          });
                                    })
                                  : const SizedBox.shrink(),
                            )
                    ],
                  ));
      },
    );
  }
}

Future<void> createCategory(String category, BuildContext context) async {
  var uid = FirebaseAuth.instance.currentUser!.uid;
  final CollectionReference ref = FirebaseFirestore.instance.collection(uid);
  if (uid.isNotEmpty) {
    return await ref.doc(category).set(
        {'category': category, 'url': FieldValue.arrayUnion([])}).then((value) {
      return LoadingScreen.inatance().hide();
    });
  } else {
    return;
  }
}

Future<void> uplaodImage(
    File file, BuildContext context, String selectedCategory) async {
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
  return await collectionReference
      .doc(selectedCategory)
      .update({'url': FieldValue.arrayUnion(data)}).then((value) => print(''));
}
