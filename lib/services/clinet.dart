import 'package:dio/dio.dart';

class Client {
  static final String _baseUrl = 'https://coded-meditation.eapi.joincoded.com';
  static final Dio dio = Dio(BaseOptions(baseUrl: _baseUrl));
}
