import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../provider/category_provider.dart';
import '../../../provider/wardRobe_provider.dart';
import '../../../utils/color_utils.dart';
import 'picker_controller.dart';

class OverlayScreen {
  //Singelton Pattern
  OverlayScreen._sharedInstance();
  static final OverlayScreen _shared = OverlayScreen._sharedInstance();
  factory OverlayScreen.inatance() => _shared;

  OverlayScreenController? _controller;

  void show({
    required BuildContext context,
    required String text,
    required Function functionForPickAppImage,
    required Function functionForPicCameraImage,
  }) {
    if (_controller?.update(
          text,
          functionForPicCameraImage,
          functionForPickAppImage,
        ) ??
        false) {
      return;
    } else {
      _controller = _showOverlay(
          context: context,
          text: text,
          functionForPickedAppImage: functionForPickAppImage,
          pickedFromCamera: functionForPicCameraImage);
    }
  }

  void hide() {
    _controller?.close();
    _controller = null;
  }

  OverlayScreenController _showOverlay(
      {required BuildContext context,
      required String text,
      required Function functionForPickedAppImage,
      required Function pickedFromCamera}) {
    final _text = StreamController<String>();
    _text.add(text);

    // get the size
    final state = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final overlay = OverlayEntry(
      builder: (context) {
        final _provider = Provider.of<WardRobeProvider>(context);
        return Material(
          color: Colors.black.withAlpha(150),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () {
                        OverlayScreen.inatance().hide();
                      },
                      child: const Icon(
                        Icons.keyboard_arrow_left,
                        color: Colors.white,
                        size: 34,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
                pickerButton(context,
                    imagePickedFrom: pickedFromCamera,
                    title: "Pick Image Using Camera"),
                SizedBox(
                  height: 10,
                ),
                pickerButton(context,
                    imagePickedFrom: functionForPickedAppImage,
                    title: "Pick Image From App")
              ],
            ),
          ),
        );
      },
    );
    state.insert(overlay);
    return OverlayScreenController(
      close: () {
        _text.close();
        overlay.remove();
        return true;
      },
      update: (text, functionForPickAppImage, functionForpickCameraImage) {
        _text.add(text);
        return true;
      },
    );
  }
}

GestureDetector pickerButton(
  BuildContext context, {
  required Function imagePickedFrom,
  required String title,
}) {
  return GestureDetector(
    onTap: () {
      imagePickedFrom();
    },
    child: Container(
      decoration: BoxDecoration(
          color: Colors.white38, borderRadius: BorderRadius.circular(20)),
      height: 80,
      width: MediaQuery.of(context).size.width * 0.70,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: Text(title),
      ),
    ),
  );
}
