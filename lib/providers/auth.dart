import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:justclass/models/user.dart';
import 'package:justclass/utils/api_call.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthType { FIREBASE_EMAIL_PASS, OAUTH_GOOGLE, OAUTH_FACEBOOK }

extension AuthTypes on AuthType {
  String get name {
    switch (this) {
      case AuthType.FIREBASE_EMAIL_PASS:
        return "Email and Password";
      case AuthType.OAUTH_GOOGLE:
        return "Google Account";
      case AuthType.OAUTH_FACEBOOK:
        return "Facebook Account";
      default:
        return "";
    }
  }
}

class Auth with ChangeNotifier {
  final _googleSignIn = GoogleSignIn(scopes: ['email']);
  User _user;
  AuthType _type;
  final _prefsUserKey = 'user';

  User get user => _user;

  AuthType get authType => _type;

  Future<bool> tryAutoSignIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!prefs.containsKey(_prefsUserKey)) return false;

      final data = json.decode(prefs.getString(_prefsUserKey)) as Map<String, dynamic>;
      _user = User(
        uid: data['id'],
        email: data['email'],
        displayName: data['displayName'],
        photoUrl: data['photoUrl'],
      );

      notifyListeners();
      return true;
    } catch (error) {
      throw error;
    }
  }

  Future<void> signInGoogle() async {
    try {
      final user = await _googleSignIn.signIn();
      if (user == null) return Future.value();

      _type = AuthType.OAUTH_GOOGLE;
      print('Auth Type: ${_type.name}');

      await _storeUserData(user);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> _storeUserData(dynamic anyUser) async {
    switch (_type) {
      case AuthType.OAUTH_GOOGLE:
        final ggUser = anyUser as GoogleSignInAccount;
        _user = User(
          uid: ggUser.id,
          email: ggUser.email,
          displayName: ggUser.displayName,
          photoUrl: ggUser.photoUrl,
        );
        break;
      case AuthType.FIREBASE_EMAIL_PASS:
        // TODO: Handle this case.
        break;
      case AuthType.OAUTH_FACEBOOK:
        // TODO: Handle this case.
        break;
    }
    await ApiCall.postUserData(_user);
    persistUserData();
  }

  Future<void> persistUserData() async {
    if (_user == null) return;

    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
        _prefsUserKey,
        json.encode({
          'uid': _user.uid,
          'email': _user.email,
          'displayName': _user.displayName,
          'photoUrl': _user.photoUrl,
        }));
  }

  Future<void> signOut() async {
    (await SharedPreferences.getInstance()).clear();

    try {
      switch (_type) {
        case AuthType.OAUTH_GOOGLE:
          await _googleSignIn.signOut();
          break;
        case AuthType.FIREBASE_EMAIL_PASS:
          // TODO: Handle this case.
          break;
        case AuthType.OAUTH_FACEBOOK:
          // TODO: Handle this case.
          break;
        default:
          return;
      }
    } finally {
      _user = null;
      _type = null;
    }
  }
}
