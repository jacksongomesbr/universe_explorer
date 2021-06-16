import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';


class AuthService extends ChangeNotifier {
  var _user;

  get user => _user;

  set user(value) => _user = value;

  Future logout() {
    _user = null;
    notifyListeners();
    return user;
  }

  Future login() {
    notifyListeners();
  }
}