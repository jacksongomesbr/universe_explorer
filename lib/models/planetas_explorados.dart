import 'package:flutter/foundation.dart';

class LoggedUser extends ChangeNotifier {
  String _username;
  String _password;

  void clear() {
    _username = null;
    _password = null;
    notifyListeners();
  }

  void signIn(String username, String password) {
    _username = username;
    _password = password;
    notifyListeners();
  }

  String get username => _username;
}
