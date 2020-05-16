import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:justclass/models/class_details_data.dart';
import 'package:justclass/models/member.dart';
import 'package:justclass/models/user.dart';
import 'package:justclass/providers/class.dart';
import 'package:justclass/utils/http_exception.dart';
import 'package:justclass/utils/test.dart';
import 'package:justclass/widgets/create_class_form.dart';

class ApiCall {
  static const _headers = {'Content-type': 'application/json', 'Accept': 'application/json'};

  static checkInternetConnection() {
    // TODO: check internet
  }

  static Future<bool> postUserData(User user) async {
    try {
      checkInternetConnection();
      const url = 'https://justclass-da0b0.appspot.com/api/v1/user';
      final response = await http.post(
        url,
        headers: _headers,
        body: json.encode({
          'localId': user.uid,
          'displayName': user.displayName,
          'email': user.email,
          'photoUrl': user.photoUrl,
        }),
      );
      if (response.statusCode >= 400)
        throw HttpException(message: 'Unable to update user data. Status code: ${response.statusCode}.');

      final isNew = json.decode(response.body)['newUser'];
      return isNew;
    } catch (error) {
      throw error;
    }
  }

  static Future<Class> createClass(String uid, CreateClassFormData data) async {
    try {
      await Future.delayed(Duration(seconds: 5));
      checkInternetConnection();
      final url = 'https://justclass-da0b0.appspot.com/api/v1/classroom/$uid';
      final response = await http.post(
        url,
        headers: _headers,
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
      final response = await http.get(url, headers: _headers);
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
      final response = await http.put(url, headers: _headers);
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
      final response = await http.delete(url, headers: _headers);
      if (response.statusCode >= 400) throw HttpException(message: 'Unable to remove class!');
    } catch (error) {
      throw error;
    }
  }

  static Future<void> updateClassDetails(String uid, String cid, ClassDetailsData data) async {
    try {
      checkInternetConnection();
      final url = 'https://justclass-da0b0.appspot.com/api/v1/classroom/$uid';
      final response = await http.patch(url,
          headers: _headers,
          body: json.encode({
            'classroomId': cid,
            'title': data.title,
            'subject': data.subject,
            'section': data.section,
            'room': data.room,
            'theme': data.theme,
            'description': data.description,
            'studentsNotePermission': data.permissionCode.name,
          }));
      if (response.statusCode >= 400) throw HttpException(message: 'Unable to update class info!');
    } catch (error) {
      throw error;
    }
  }

  static Future<String> requestNewPublicCode(String uid, String cid) async {
    try {
      checkInternetConnection();
      final url = 'https://justclass-da0b0.appspot.com/api/v1/classroom/$uid?requestNewPublicCode=true';
      final response = await http.patch(url, headers: _headers, body: json.encode({'classroomId': cid}));
      if (response.statusCode >= 400) throw HttpException(message: 'Unable to generate new class code!');
      final newCode = json.decode(response.body)['publicCode'];
      return newCode;
    } catch (error) {
      throw error;
    }
  }

  static Future<Class> fetchClassDetails(String cid) async {
    try {
      checkInternetConnection();
      await Test.delay(1);
      // TODO: Implementation for class info screen in student mode
    } catch (error) {
      throw error;
    }
  }

  static Future<List<Member>> fetchMemberList(String uid, String cid) async {
    try {
      checkInternetConnection();
      final url = 'https://justclass-da0b0.appspot.com/api/v1/classroom/members/$uid/$cid';
      final response = await http.get(url, headers: _headers);
      if (response.statusCode >= 400) throw HttpException(message: 'Unable to fetch member list!');

      final memberData = json.decode(response.body) as List<dynamic>;
      final members = memberData
          .map((m) => Member(
                uid: m['localId'],
                photoUrl: m['photoUrl'],
                displayName: m['displayName'],
                joinDatetime: m['joinDatetime'],
                role: ClassRoles.getType(m['role']),
              ))
          .toList();
      members
        ..addAll([
          Member(
            displayName: 'Test 1',
            uid: '2',
            role: ClassRole.COLLABORATOR,
            joinDatetime: 123,
            photoUrl: 'https://placekitten.com/156/156',
          ),
          Member(
            displayName: 'Test 1',
            uid: '1',
            role: ClassRole.STUDENT,
            joinDatetime: 123,
            photoUrl: 'https://placekitten.com/151/151',
          ),
          Member(
            displayName: 'Test 2',
            uid: '1',
            role: ClassRole.STUDENT,
            joinDatetime: 123,
            photoUrl: 'https://placekitten.com/149/149',
          ),
          Member(
            displayName: 'Test 3',
            uid: '1',
            role: ClassRole.STUDENT,
            joinDatetime: 123,
            photoUrl: null,
          ),
          Member(
            displayName: 'Test 4',
            uid: '1',
            role: ClassRole.STUDENT,
            joinDatetime: 123,
            photoUrl: 'https://placekitten.com/153/153',
          ),
          Member(
            displayName: 'Test 5',
            uid: '1',
            role: ClassRole.STUDENT,
            joinDatetime: 123,
            photoUrl: 'https://placekitten.com/150/150',
          ),
          Member(
            displayName: 'Test 6',
            uid: '1',
            role: ClassRole.STUDENT,
            joinDatetime: 123,
            photoUrl: 'https://placekitten.com/154/154',
          ),
          Member(
            displayName: 'Test 7',
            uid: '1',
            role: ClassRole.STUDENT,
            joinDatetime: 123,
            photoUrl: 'https://placekitten.com/155/155',
          ),
          Member(
            displayName: 'Test 8',
            uid: '1',
            role: ClassRole.STUDENT,
            joinDatetime: 123,
            photoUrl: 'https://placekitten.com/156/156',
          ),
          Member(
            displayName: 'A Test 9',
            uid: '1',
            role: ClassRole.STUDENT,
            joinDatetime: 123,
            photoUrl: null,
          ),
          Member(
            displayName: 'Test 10',
            uid: '1',
            role: ClassRole.STUDENT,
            joinDatetime: 123,
            photoUrl: 'https://placekitten.com/150/150',
          )
        ]);
      return members;
    } catch (error) {
      throw error;
    }
  }

  static Future<void> removeCollaborator() async {
    await Future.delayed(Duration(seconds: 1));
    throw HttpException(message: 'Collab cannot be removed');
  }

  static Future<void> removeStudent() async {
    await Future.delayed(Duration(seconds: 1));
    throw HttpException(message: 'Student cannot be removed');
  }

  static Future<List<Member>> fetchSuggestedMembers(
    String uid,
    String cid,
    ClassRole role,
    String keyword,
  ) async {
    try {
      checkInternetConnection();
      final url = 'https://justclass-da0b0.appspot.com/api/v1/classroom/lookup/$uid/$cid/${role.name}?keyword=$keyword';
      final response = await http.get(url, headers: _headers);
      if (response.statusCode >= 400) throw HttpException(message: 'Unable to suggest users!');

      final memberData = json.decode(response.body) as List<dynamic>;
      final members = memberData
          .map((u) => Member(
                uid: u['uid'],
                email: u['email'],
                displayName: u['displayName'],
                photoUrl: u['photoUrl'],
              ))
          .toList();
      members.addAll([
        Member(
          uid: '1',
          email: 'test1@gmail.com',
          displayName: 'Test 1',
          photoUrl: 'https://placekitten.com/100/100',
        ), Member(
          uid: '2',
          email: 'test2@gmail.com',
          displayName: 'Test 2',
          photoUrl: 'https://placekitten.com/101/101',
        ),
      ]);
      return members;
    } catch (error) {
      throw error;
    }
  }
}
