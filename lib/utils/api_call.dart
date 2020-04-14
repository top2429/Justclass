import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:justclass/models/user.dart';
import 'package:justclass/providers/class.dart';
import 'package:justclass/utils/http_exception.dart';
import 'package:justclass/widgets/create_class_form.dart';

class ApiCall {
  static Future<bool> postUserData(User user) async {
    const url = 'https://justclass-da0b0.appspot.com/api/v1/user';
    try {
      // TODO check internet connection
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
      final isNew = json.decode(response.body)['newUser'];
      return Future.value(isNew);
    } catch (error) {
      throw HttpException("Something went wrong!");
    }
  }

  static Future<Class> createClass(String uid, NewClassData data) async {
    final url = 'https://justclass-da0b0.appspot.com/api/v1/classroom/$uid';
    try {
      // TODO check internet connection
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

      final info = json.decode(response.body);
      final newClass = Class(
        cid: info['classroomId'],
        publicCode: info['classroomId'],
        permissionCode: info['studentsNotePermission'],
        role: ClassRoles.getType(info['role']),
        title: data.title,
        section: data.section,
        subject: data.subject,
        description: data.description,
        room: data.room,
        theme: data.theme,
      );

      return Future.value(newClass);
    } catch (error) {
      throw HttpException('Unable to create new class!');
    }
  }
}
