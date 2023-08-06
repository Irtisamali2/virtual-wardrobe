import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

import '../../Models/data_models.dart';
import '../../provider/shared_pref_provider.dart';
import '../../utils/back_button.dart';
import '../../utils/color_utils.dart';
import '../../utils/shimmer.dart';

class AllCategories extends StatelessWidget {
  const AllCategories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<SharedPrefProvider>(
      context,
    );
    final DataModel model = DataModel();
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          hexStringToColor("CB2B93"),
          hexStringToColor("9546C4"),
          hexStringToColor("5E61F4")
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * .05,
            ),
            backButton(
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(
              height: 20,
            ),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection(FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  // if (snapshot.connectionState == ConnectionState.waiting) {
                  //   return shimer();
                  // }
                  if (!snapshot.hasData) {
                    return shimer();
                  } else {
                    final data = snapshot.data;
                    final List<dynamic> category =
                        data!.docs.map((doc) => doc.id).toList();

                    return _provider.hasData == false
                        ? Column(
                            children: [shimer(), shimer(), shimer()],
                          )
                        : Expanded(
                            child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            // padding: const EdgeInsets.all(20),
                            itemCount: data == null ? 1 : category.length,
                            itemBuilder: (context, categoryindex) {
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white.withAlpha(150),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          padding: const EdgeInsets.all(10),
                                          child: Center(
                                            child: Text(
                                              data == null
                                                  ? model.category
                                                  : category[categoryindex],
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            FirebaseFirestore.instance
                                                .collection(FirebaseAuth
                                                    .instance.currentUser!.uid)
                                                .doc(category[categoryindex])
                                                .delete();
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.white.withAlpha(150),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            padding: const EdgeInsets.all(10),
                                            child: const Center(
                                              child: Text(
                                                'Delete',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.red,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.34,
                                    child: ListView(
                                      physics: const BouncingScrollPhysics(),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      scrollDirection: Axis.horizontal,
                                      children: List.generate(
                                        data == null
                                            ? _provider
                                                .imageUrlSharedPref.length
                                            : data.docs[categoryindex]['url']
                                                .length,
                                        (index) {
                                          var selectedDoc =
                                              data.docs[categoryindex];
                                          // _provider.loadImageUrls(index);
                                          _provider.setSharedPref(
                                              category: category[categoryindex],
                                              key: category[categoryindex],
                                              url: selectedDoc['url']);
                                          return Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                selectedDoc['url'][index] !=
                                                        null
                                                    ? ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        child: data == null
                                                            ? Image.memory(
                                                                _provider.imageUrlSharedPref[
                                                                        index]
                                                                    as Uint8List)
                                                            : Image.network(
                                                                selectedDoc[
                                                                        'url']
                                                                    [index],
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.20,
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.5,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                      )
                                                    : const SizedBox.shrink(),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                backButton(
                                                    iconColor: Colors.red
                                                        .withAlpha(150),
                                                    padding: 0,
                                                    alignment: Alignment.center,
                                                    onTap: () {
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid)
                                                          .doc(category[
                                                              categoryindex])
                                                          .update({
                                                        'url': FieldValue
                                                            .arrayRemove([
                                                          selectedDoc['url']
                                                              [index]
                                                        ])
                                                      });
                                                    },
                                                    icon: Ionicons.remove),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        growable: true,
                                      ),
                                    ),
                                  )
                                ],
                              );
                            },
                          ));
                  }
                })
          ],
        ),
      ),
    );
  }
}
