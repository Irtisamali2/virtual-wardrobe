import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../provider/category_provider.dart';
import '../../../provider/wardRobe_provider.dart';
import '../../../utils/back_button.dart';
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
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * .05,
              ),
              backButton(
                onTap: () {
                  _provider.getCheck(false);
                  OverlayScreen.inatance().hide();
                },
              ),
              Expanded(
                  child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    pickerButton(
                      context,
                      imagePickedFrom: pickedFromCamera,
                      title: "Camera Image",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    pickerButton(
                      context,
                      imagePickedFrom: functionForPickedAppImage,
                      title: "App Image",
                    ),
                  ],
                ),
              ))
            ],
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
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      height: 60,
      width: MediaQuery.of(context).size.width * 0.70,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: Text(title),
      ),
    ),
  );
}
