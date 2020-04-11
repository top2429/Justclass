import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:justclass/models/user.dart';
import 'package:justclass/utils/http_exception.dart';

class ApiCall {
  static Future<bool> postUserData(User user) async {
    const url = 'https://justclass-da0b0.appspot.com/api/v1/user';
    try {
      final response = await http.post(
        url,
        headers: {'Content-type': 'application/json', 'Accept': 'application/json'},
        body: json.encode({
          'localId': user.id,
          'displayName': user.displayName,
          'email': user.email,
          'photoUrl': user.photoUrl,
        }),
      );
      final isNew = json.decode(response.body)['newUser'];
      return Future.value(isNew);
    } catch (error) {
      throw HttpException("Something went wrong!");
    }
  }
}
