import 'package:dio/dio.dart';

Dio dio() {
  Dio dio = Dio();
  dio.options.baseUrl = 'https://academy.abdullah-hatahet.com/api/';
  dio.options.headers['Accept'] = 'application/json';

  return dio;
}
