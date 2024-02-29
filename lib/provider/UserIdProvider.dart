import 'package:flutter/material.dart';

class UserIdProvider extends ChangeNotifier {
  String? userId;

  void setUserId(String? id) {
    userId = id;
    notifyListeners();
  }
}
