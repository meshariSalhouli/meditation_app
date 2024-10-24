import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:meditation_app/models/user.dart';
import 'package:meditation_app/services/clinet.dart';

class AuthServices {
  Future<String> signup({
    required String username,
    required String password,
    String? imagePath,
    String? defaultImage,
  }) async {
    late String token;
    try {
      Response response = await Client.dio.post(
        "/signup",
        data: FormData.fromMap({
          "username": username,
          "password": password,
          if (imagePath != null)
            "image": await MultipartFile.fromFile(imagePath)
          else
            "image": defaultImage,
        }),
      );
      token = response.data["token"];
    } catch (error) {
      print("error");
    }
    return token;
  }

  Future<String> signin({
    required String username,
    required String password,
  }) async {
    Response response = await Client.dio.post("/signin", data: {
      "username": username,
      "password": password,
    });
    return response.data["token"];
  }
}

// List<int> numb = [
//   1,
//   2,
//   3,
//   4,
//   if (true) 5 else 6,
//   if (true) ...[10, 20]
// ];
