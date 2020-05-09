import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:justclass/models/user.dart';
import 'package:justclass/providers/class.dart';
import 'package:justclass/utils/http_exception.dart';
import 'package:justclass/utils/test.dart';
import 'package:justclass/widgets/create_class_form.dart';

class ApiCall {
  static checkInternetConnection() {
    // TODO: check internet
  }

  static Future<bool> postUserData(User user) async {
    try {
      checkInternetConnection();

      const url = 'https://justclass-da0b0.appspot.com/api/v1/user';
      final response = await http.post(
        url,
        headers: {'Content-type': 'application/json', 'Accept': 'application/json'},
        body: json.encode({
          'localId': user.uid,
          'displayName': user.displayName,
          'email': user.email,
          'photoUrl': user.photoUrl,
        }),
      );
      if (response.statusCode >= 400) throw HttpException(message: 'Unable to update user data');

      final isNew = json.decode(response.body)['newUser'];
      return isNew;
    } catch (error) {
      throw error;
    }
  }

  static Future<Class> createClass(String uid, CreateClassFormData data) async {
    try {
      checkInternetConnection();

      final url = 'https://justclass-da0b0.appspot.com/api/v1/classroom/$uid';
      final response = await http.post(
        url,
        headers: {'Content-type': 'application/json', 'Accept': 'application/json'},
        body: json.encode({
          'title': data.title,
          'section': data.section,
          'subject': data.subject,
          'room': data.room,
          'theme': data.theme,
        }),
      );
      if (response.statusCode >= 400) throw HttpException(message: 'Unable to create new class!');

      final info = json.decode(response.body);
      final newClass = Class.fromJson(info);

      return newClass;
    } catch (error) {
      throw error;
    }
  }

  static Future<List<Class>> fetchClassList(String uid) async {
    try {
      checkInternetConnection();

      final url = 'https://justclass-da0b0.appspot.com/api/v1/classroom/$uid';
      final response = await http.get(url, headers: {'Accept': 'application/json'});

      if (response.statusCode >= 400) throw HttpException(message: 'Unable to fetch class data!');

      final List<Class> classList = [];
      final classesData = json.decode(response.body) as List<dynamic>;
      classesData.forEach((cls) => classList.add(Class.fromJson(cls)));
      return classList;
    } catch (error) {
      throw error;
    }
  }

  static Future<Class> joinClassWithCode(String uid, String publicCode) async {
    try {
      checkInternetConnection();
      final url = 'https://justclass-da0b0.appspot.com/api/v1/classroom/$uid/$publicCode';
      final response = await http.put(url, headers: {'Accept': 'application/json'});
      if (response.statusCode == 417)
        throw HttpException(message: 'Class code does not exist!');
      else if (response.statusCode >= 400) throw HttpException(message: 'Unable to join class!');

      final data = json.decode(response.body);
      return Class.fromJson(data);
    } catch (error) {
      throw error;
    }
  }

  static Future<void> removeOwnedClass(String uid, String cid) async {
    try {
      checkInternetConnection();
      final url = 'https://justclass-da0b0.appspot.com/api/v1/classroom/$uid/$cid';
      final response = await http.delete(url, headers: {'Accept': 'application/json'});
      if (response.statusCode >= 400) throw HttpException(message: 'Unable to remove class!');
    } catch (error) {
      throw error;
    }
  }

  static Future<Class> fetchClassDetails(String cid) async {
    try {
      await Test.delay(1);
    } catch (error) {
      throw error;
    }
  }
}
