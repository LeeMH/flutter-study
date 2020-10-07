import 'package:flutter/material.dart';

class SimpleState extends ChangeNotifier {
  String _email;

  void setEmail(String email) {
    this._email = email;
  }

  String get email => _email;
}
