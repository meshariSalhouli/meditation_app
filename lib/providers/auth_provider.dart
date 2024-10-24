import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:meditation_app/models/user.dart';
import 'package:meditation_app/services/auth_services.dart';
import 'package:meditation_app/services/clinet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  static const tokenKey = "token";

  String token = "";
  late User user;
  Future<void> signup({required User user}) async {
    token = await AuthServices().signup(user: user);
    setToken(token);
    print(token);
    notifyListeners();
  }

  Future<bool> signin({required User user}) async {
    try {
      token = await AuthServices().signin(user: user);
      setToken(token);
      print(token);
      notifyListeners();

      return true;
    } on Exception catch (e) {
      return false;
    }
  }

  void setToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(tokenKey, token);
  }

  bool isAuth() {
    if (token.isNotEmpty && Jwt.getExpiryDate(token)!.isAfter(DateTime.now())) {
      user = User.fromJson(Jwt.parseJwt(token));
      Client.dio.options.headers[HttpHeaders.authorizationHeader] =
          "Bearer $token";
      return true;
    }
    return false;
  }

  Future<void> initializeAuth() async {
    await _getToken();
  }

  Future<void> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString(tokenKey) ?? "";
    notifyListeners();
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(tokenKey);
    token = "";

    Client.dio.options.headers.remove(HttpHeaders.authorizationHeader);
    notifyListeners();
  }
}
