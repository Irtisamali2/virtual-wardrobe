import 'package:flutter/foundation.dart' show immutable;

typedef OverlayScreen = bool Function();
typedef UpdateOverlayScreen = bool Function(
  String text,
  Function functionForPickAppImage,
  Function functionForpickCameraImage,
);

@immutable
class OverlayScreenController {
  final OverlayScreen close;
  final UpdateOverlayScreen update;

  const OverlayScreenController({
    required this.close,
    required this.update,
  });
}
