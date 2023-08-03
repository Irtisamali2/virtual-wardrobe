import 'package:flutter/material.dart';

class SelectCategory extends ChangeNotifier {
  int _index = 0;
  int get selectedIndex => _index;

  void selctIndex(int index) {
    _index = index;
    notifyListeners();
  }
}
