import 'dart:convert';

import 'package:login/model/api_responce.dart';
import 'package:http/http.dart' as http;

Future<ApiResponce> register(
    String user_name, String email, String password, String c_password) async {
  ApiResponce apiResponce = ApiResponce();
  final url = Uri.parse('uri');
  final body = {
    'user_name': user_name,
    'email': email,
    'password': password,
    'c_password': c_password
  };
  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      print('Response:${response.body}');
    } else {
      print("Error:${response.statusCode}");
      print("Message:${response.body}");
    }
  } catch (e) {
    print("Exception:$e");
  }
  return apiResponce;
}
