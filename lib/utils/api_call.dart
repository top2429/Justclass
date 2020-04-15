import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:justclass/models/user.dart';
import 'package:justclass/providers/class.dart';
import 'package:justclass/utils/http_exception.dart';
import 'package:justclass/widgets/create_class_form.dart';

class ApiCall {
  static Future<bool> postUserData(User user) async {
    // TODO check internet connection

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
    if (response.statusCode != 200) throw HttpException();

    final isNew = json.decode(response.body)['newUser'];
    return Future.value(isNew);
  }

  static Future<Class> createClass(String uid, NewClassData data) async {
    // TODO check internet connection

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
  }
}
