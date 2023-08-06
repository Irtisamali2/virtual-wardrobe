import 'package:firebase_signin/reusable_widgets/reusable_widget.dart';
import 'package:flutter/material.dart';

import '../../../utils/color_utils.dart';
import '../../../utils/loader/loading_screen.dart';

createCategoryBottomSheet(
    BuildContext context, TextEditingController controller, Function function) {
  return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom),
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Create New Category',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 20,
              ),
              reusableTextField(
                  'Add Category Name', Icons.category, false, controller),
              firebaseUIButton(context, 'Add', () {
                function();
                Navigator.pop(context);
                LoadingScreen.inatance()
                    .show(context: context, text: 'Creating...');
              })
            ],
          ),
        );
      });
}
