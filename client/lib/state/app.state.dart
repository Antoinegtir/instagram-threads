import 'package:flutter/material.dart';

class AppStates extends ChangeNotifier {
  bool _isBusy = false;
  bool get isbusy => _isBusy;

  set isBusy(bool value) {
    if (value != _isBusy) {
      _isBusy = value;
      notifyListeners();
    }
  }
}
