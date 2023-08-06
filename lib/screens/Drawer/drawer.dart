import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../provider/category_provider.dart';
import '../../utils/color_utils.dart';
import '../Home/component/create_category_bottom_sheet.dart';
import '../Home/component/upload_image_bottom_sheet.dart';
import '../categories/all_categories.dart';
import '../signin_screen.dart';

Widget drawer(
    {required BuildContext context,
    required List category,
    required Function addImageTofireBase,
    required Function pickImage,
    required Function onTap,
    required TextEditingController controller,
    required addCategoryFunction}) {
  final _provider = Provider.of<SelectCategory>(context, listen: false);
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 40),
    child: Drawer(
      width: MediaQuery.of(context).size.width * 0.20,
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
            Column(
                children: List.generate(
              drawerIcons.length,
              (index) =>
                  Consumer<SelectCategory>(builder: (context, value, __) {
                return Column(
                  children: [
                    GestureDetector(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: value.drawerIndex == index
                                ? Colors.white.withAlpha(150)
                                : Colors.transparent),
                        child: Icon(
                          drawerIcons[index],
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        value.getDrawerIndex(index);
                        if (index == 0) {
                          onTap();
                          showBottomSheetForImagePicker(
                              category: category,
                              addImageTofireBase: addImageTofireBase,
                              context: context,
                              onTap: pickImage);
                        }
                        if (index == 1) {
                          onTap();
                          // Navigator.pop(context);
                          createCategoryBottomSheet(
                            context,
                            controller,
                            addCategoryFunction,
                          );
                        }
                        if (index == 2) {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const AllCategories(),
                          ));
                          onTap();
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                );
              }),
            )),
            const Spacer(),
            GestureDetector(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.white.withAlpha(150)),
                child: Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                ),
              ),
              onTap: () async {
                final SharedPreferences _pref =
                    await SharedPreferences.getInstance();
                FirebaseAuth.instance.signOut().then((_) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const SignInScreen(),
                  ));
                  _pref.remove('email');

                  print('logout');
                });
              },
            ),
          ],
        ),
      ),
    ),
  );
}

const drawerIcons = [
  Icons.photo,
  Ionicons.create,
  Icons.category,
];
