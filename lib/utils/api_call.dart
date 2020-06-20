import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:justclass/models/class_details_data.dart';
import 'package:justclass/models/member.dart';
import 'package:justclass/models/note.dart';
import 'package:justclass/models/notification.dart';
import 'package:justclass/models/user.dart';
import 'package:justclass/providers/class.dart';
import 'package:justclass/utils/http_exception.dart';
import 'package:justclass/utils/internet_connection.dart';
import 'package:justclass/widgets/create_class_form.dart';
import 'package:mime/mime.dart';

import '../keys.dart';

class ApiCall {
  static const _headers = {'Content-type': 'application/json', 'Accept': 'application/json'};

  static Future<void> checkInternetConnection() async {
    final result = await InternetConnection().isConnected();
    if (!result) throw HttpException(message: 'No internet connection!');
  }

  static Future<dynamic> signUpEmailPasswordFirebase(String email, String password) async {
    // Reference: https://firebase.google.com/docs/reference/rest/auth#section-create-email-password
    const url = 'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$webAPIKey';
    try {
      await checkInternetConnection();
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': false, // we've decided not to use token, next time :)
          }));

      final data = json.decode(response.body) as Map<String, dynamic>;
      if (data['error'] != null) {
        String message = '';
        switch (data['error']['message']) {
          case 'EMAIL_EXISTS':
            message = 'This email address is already in use.';
            break;
          case 'OPERATION_NOT_ALLOWED':
            message = 'Password sign-in is disabled!';
            break;
          case 'TOO_MANY_ATTEMPTS_TRY_LATER':
            message = 'All requests are blocked. Try again later.';
            break;
          default:
            message = 'Something went wrong!';
        }
        throw HttpException(message: message);
      }

      return data;
    } catch (error) {
      throw error;
    }
  }

  static Future<dynamic> signInEmailPasswordFirebase(String email, String password) async {
    // Reference: https://firebase.google.com/docs/reference/rest/auth#section-sign-in-email-password
    try {
      await checkInternetConnection();
      const url = 'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$webAPIKey';
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': false, // we've decided not to use token
          }));

      final data = json.decode(response.body) as Map<String, dynamic>;
      if (data['error'] != null) {
        String message = '';
        switch (data['error']['message']) {
          case 'EMAIL_NOT_FOUND':
          case 'INVALID_PASSWORD':
            message = 'The email address or password was wrong!';
            break;
          case 'USER_DISABLED':
            message = 'This account has been disabled!';
            break;
          default:
            message = 'Something went wrong!';
        }
        throw HttpException(message: message);
      }

      return data;
    } catch (error) {
      throw error;
    }
  }

  static Future<bool> postUserData(User user) async {
    try {
      await checkInternetConnection();
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
        throw HttpException(message: 'Unable to update user data! ${response.statusCode}.');

      final isNew = json.decode(response.body)['newUser'];
      return isNew;
    } catch (error) {
      throw error;
    }
  }

  static Future<Class> createClass(String uid, CreateClassFormData data) async {
    try {
      await Future.delayed(Duration(seconds: 5));
      await checkInternetConnection();
      final url = 'https://justclass-da0b0.appspot.com/api/v1/classroom/$uid';
      final response = await http.post(
        url,
        headers: _headers,
        body: json.encode({
          'title': data.title.trim(),
          'section': data.section?.trim(),
          'subject': data.subject?.trim(),
          'room': data.room?.trim(),
          'theme': data.theme,
        }),
      );
      if (response.statusCode >= 400)
        throw HttpException(message: 'Unable to create new class! ${response.statusCode}');

      final info = json.decode(response.body);
      final newClass = Class.fromJson(info);

      return newClass;
    } catch (error) {
      throw error;
    }
  }

  static Future<List<Class>> fetchClassList(String uid) async {
    try {
      await checkInternetConnection();
      final url = 'https://justclass-da0b0.appspot.com/api/v1/classroom/$uid';
      final response = await http.get(url, headers: _headers);
      if (response.statusCode >= 400)
        throw HttpException(message: 'Unable to fetch class data! ${response.statusCode}');

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
      await checkInternetConnection();
      final url = 'https://justclass-da0b0.appspot.com/api/v1/classroom/$uid/$publicCode';
      final response = await http.put(url, headers: _headers);
      if (response.statusCode == 417)
        throw HttpException(message: 'Class code does not exist!');
      else if (response.statusCode >= 400) throw HttpException(message: 'Unable to join class! ${response.statusCode}');

      final data = json.decode(response.body);
      return Class.fromJson(data);
    } catch (error) {
      throw error;
    }
  }

  static Future<void> removeOwnedClass(String uid, String cid) async {
    try {
      await checkInternetConnection();
      final url = 'https://justclass-da0b0.appspot.com/api/v1/classroom/$uid/$cid';
      final response = await http.delete(url, headers: _headers);
      if (response.statusCode >= 400) throw HttpException(message: 'Unable to remove class! ${response.statusCode}');
    } catch (error) {
      throw error;
    }
  }

  static Future<void> updateClassDetails(String uid, String cid, ClassDetailsData data) async {
    try {
      await checkInternetConnection();
      final url = 'https://justclass-da0b0.appspot.com/api/v1/classroom/$uid';
      final response = await http.patch(url,
          headers: _headers,
          body: json.encode({
            'classroomId': cid,
            'title': data.title.trim(),
            'subject': data.subject?.trim(),
            'section': data.section?.trim(),
            'room': data.room?.trim(),
            'theme': data.theme,
            'description': data.description?.trim(),
            'studentsNotePermission': data.permissionCode.name,
          }));
      if (response.statusCode >= 400)
        throw HttpException(message: 'Unable to update class info! ${response.statusCode}');
    } catch (error) {
      throw error;
    }
  }

  static Future<String> requestNewPublicCode(String uid, String cid) async {
    try {
      await checkInternetConnection();
      final url = 'https://justclass-da0b0.appspot.com/api/v1/classroom/$uid?requestNewPublicCode=true';
      final response = await http.patch(
        url,
        headers: _headers,
        body: json.encode({'classroomId': cid}),
      );
      if (response.statusCode >= 400)
        throw HttpException(message: 'Unable to generate new class code! ${response.statusCode}');
      final newCode = json.decode(response.body)['publicCode'];
      return newCode;
    } catch (error) {
      throw error;
    }
  }

  static Future<void> fetchClassDetails(String cid) async {
    try {
      await checkInternetConnection();
      await Future.delayed(const Duration(seconds: 1));
      // TODO: Implementation for class info screen in student mode
    } catch (error) {
      throw error;
    }
  }

  static Future<List<Member>> fetchMemberList(String uid, String cid) async {
    try {
      await checkInternetConnection();
      final url = 'https://justclass-da0b0.appspot.com/api/v1/classroom/members/$uid/$cid';
      final response = await http.get(url, headers: _headers);
      if (response.statusCode >= 400)
        throw HttpException(message: 'Unable to fetch member list! ${response.statusCode}');

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
      return members;
    } catch (error) {
      throw error;
    }
  }

  static Future<void> removeMember(
    String uid,
    String cid,
    String memberId, {
    bool isStudent = true,
  }) async {
    try {
      checkInternetConnection();
      final url = 'https://justclass-da0b0.appspot.com/api/v1/classroom/members/$uid/$cid/$memberId';
      final response = await http.delete(url, headers: _headers);

      if (response.statusCode >= 400)
        throw HttpException(
            message: 'Unable to remove this ${isStudent ? 'student' : 'teacher'}! ${response.statusCode}');
    } catch (error) {
      throw error;
    }
  }

  static Future<List<Member>> fetchSuggestedMembers(
    String uid,
    String cid,
    ClassRole role,
    String keyword,
  ) async {
    try {
      await checkInternetConnection();
      final url = 'https://justclass-da0b0.appspot.com/api/v1/classroom/lookup/$uid/$cid/${role.name}?keyword=$keyword';
      final response = await http.get(url, headers: _headers);
      if (response.statusCode >= 400) throw HttpException(message: 'Unable to suggest users! ${response.statusCode}');

      final memberData = json.decode(response.body) as List<dynamic>;
      final members = memberData
          .map((u) => Member(
                uid: u['uid'],
                email: u['email'],
                displayName: u['displayName'],
                photoUrl: u['photoUrl'],
              ))
          .toList();
      return members;
    } catch (error) {
      throw error;
    }
  }

  static Future<void> inviteMembers(String uid, String cid, Set<String> emails, ClassRole role) async {
    try {
      await checkInternetConnection();
      final url = 'https://justclass-da0b0.appspot.com/api/v1/classroom/$uid/$cid';

      final response = await http.patch(
        url,
        headers: _headers,
        body: json.encode([
          ...emails.map((e) => {'email': e, 'role': role.name}),
        ]),
      );
      if (response.statusCode >= 400)
        throw HttpException(message: 'Unable to send invitations! ${response.statusCode}');
    } catch (error) {
      throw error;
    }
  }

  static Future<void> leaveCLass(String uid, String cid) async {
    try {
      await checkInternetConnection();
      final url = 'https://justclass-da0b0.appspot.com/api/v1/classroom/leave/$uid/$cid';

      final response = await http.delete(url, headers: _headers);
      if (response.statusCode >= 400) throw HttpException(message: 'Unable to leave class!');
    } catch (error) {
      throw error;
    }
  }

  static Future<dynamic> fetchNotifications(String uid) async {
    try {
      await checkInternetConnection();
      final url = 'https://justclass-da0b0.appspot.com/api/v1/notification/$uid';

      final response = await http.get(url, headers: _headers);
      if (response.statusCode >= 400)
        throw HttpException(message: 'Unable to fetch notifications! ${response.statusCode}');

      final notificationData = json.decode(response.body) as List<dynamic>;
      print(notificationData);
    } catch (error) {
      throw error;
    }
  }

  static Future<List<Note>> fetchNotes(String cid) async {
    try {
      await checkInternetConnection();
      final url = 'https://justclass-da0b0.appspot.com/api/v1/note/$cid';

      final response = await http.get(url, headers: _headers);

      if (response.statusCode >= 400) throw HttpException(message: 'Unable to fetch notes! ${response.statusCode}');

      final data = json.decode(response.body) as List<dynamic>;
      final List<Note> notes = data.map((note) => Note.fromJson(note)).toList();
      return notes;
    } catch (error) {
      throw error;
    }
  }

  static Future<Note> postNote(String uid, String cid, String content, Map<String, String> files) async {
    try {
      await checkInternetConnection();
      final url = 'https://justclass-da0b0.appspot.com/api/v1/note/$uid/$cid';

      // Reference: https://stackoverflow.com/questions/44841729/how-to-upload-image-in-flutter
      final request = http.MultipartRequest('POST', Uri.parse(url))..fields['content'] = content;
      files.forEach((name, path) async {
        final file = await http.MultipartFile.fromPath('attachments', path,
            filename: name, contentType: MediaType(lookupMimeType(path), ''));
        request.files.add(file);
      });
      final response = await request.send();

      if (response.statusCode >= 400) throw HttpException(message: 'Unable to post notes! ${response.statusCode}');

      final strData = await response.stream.bytesToString();
      final data = json.decode(strData);

      return Note.fromJson(data);
    } catch (error) {
      throw error;
    }
  }

  static Future<void> removeNote(String uid, String nid) async {
    try {
      await checkInternetConnection();
      final url = 'https://justclass-da0b0.appspot.com/api/v1/note/$uid/$nid';
      final response = await http.delete(url, headers: _headers);

      if (response.statusCode >= 400) throw HttpException(message: 'Unable to remove note! ${response.statusCode}');
    } catch (error) {
      throw error;
    }
  }

  static Future<dynamic> updateNote(
    String uid,
    String nid, {
    String content,
    List<String> deletedFileIds,
    Map<String, String> newFiles,
  }) async {
    try {
      await checkInternetConnection();
      final url = 'https://justclass-da0b0.appspot.com/api/v1/note/$uid/$nid';

      final request = http.MultipartRequest('PATCH', Uri.parse(url));
      if (content != null) request.fields['content'] = content;
      if (deletedFileIds != null && deletedFileIds.isNotEmpty) {
        deletedFileIds.forEach((id) {
          final file = http.MultipartFile.fromString('deletedAttachments', id);
          request.files.add(file);
        });
      }
      if (newFiles != null && newFiles.isNotEmpty) {
        newFiles.forEach((name, path) async {
          final file = await http.MultipartFile.fromPath(
            'attachments',
            path,
            filename: name,
            contentType: MediaType(lookupMimeType(path), ''),
          );
          request.files.add(file);
        });
      }
      final response = await request.send();

      if (response.statusCode >= 400) throw HttpException(message: 'Unable to update note! ${response.statusCode}');

      final strData = await response.stream.bytesToString();
      final data = json.decode(strData);

      return {
        'attachments': data['attachments'],
        'content': data['content'],
      };
    } catch (error) {
      throw error;
    }
  }

  static Future<void> downloadFile(String fileId, String filePath, Function onReceive, CancelToken token) async {
    try {
      await checkInternetConnection();
      final url = 'https://justclass-da0b0.appspot.com/api/v1/file/$fileId';
      try {
        final dio = Dio();
        await dio.download(url, filePath, onReceiveProgress: onReceive, cancelToken: token);
      } catch (error) {
        throw HttpException(message: "Unable to download the file!");
      }
    } catch (error) {
      throw error;
    }
  }

  static Future<List<Notification>> getNotificationList(String uid) async {
    try {
      await checkInternetConnection();
      final url = "https://justclass-da0b0.appspot.com/api/v1/notification/$uid";
      final response = await http.get(url, headers: _headers);

      if (response.statusCode >= 400)
        throw HttpException(message: "Unable to get notifications! ${response.statusCode}");

      final List<Notification> notList = [];
      final notData = json.decode(response.body) as List<dynamic>;
      notData.forEach((not) => notList.add(Notification.fromJson(not)));
      return notList;
    } catch (error) {
      throw (error);
    }
  }

  static Future<void> acceptInvitation(String uid, String notificationId) async {
    try {
      await checkInternetConnection();
      final url = 'https://justclass-da0b0.appspot.com/api/v1/classroom/accept/$uid/$notificationId';
      final response = await http.get(url, headers: _headers);

      if (response.statusCode >= 400)
        throw HttpException(message: "Unable to accept this invitation! ${response.statusCode}");
    } catch (error) {
      throw (error);
    }
  }
}
