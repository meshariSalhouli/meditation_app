import 'package:flutter/material.dart';

class MeditationProvider extends ChangeNotifier {
  List<String> meditation = [];

  String? _username;
  String? _password;

  // Getters for profile fields
  String? get username => _username;
  String? get password => _password;
}
