import 'package:flutter/material.dart';
import 'package:pharmacy_buddy/models/user.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(
    name: '',
    email: '',
    password: '',
  );

  User get user => _user;

  void setUser(String user) {
    _user = User.fromJson(user);
    notifyListeners();
  }
}
