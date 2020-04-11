import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class User {
  final String id;
  final String displayName;
  final String email;
  final String photoUrl;
  final String lastName;
  final String firstName;

  const User({
    @required this.id,
    @required this.email,
    @required this.displayName,
    this.photoUrl,
    this.firstName,
    this.lastName,
  });
}

enum AuthType { Email, OAuthGoogle, OAuthFacebook }

extension AuthTypeMethod on AuthType {
  String get name {
    switch (this) {
      case AuthType.Email:
        return "Email";
      case AuthType.OAuthGoogle:
        return "Google";
      case AuthType.OAuthFacebook:
        return "Facebook";
      default:
        return "";
    }
  }
}

class Auth with ChangeNotifier {
  final _firebaseAuth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn(scopes: ['email']);

  User _user;
  AuthType _type;

  User get user => _user;

  AuthType get authType => _type;

  Future<void> signInGoogle() async {
    try {
      await signOut();
      final user = await _googleSignIn.signIn();
      if (user == null) return;

      _type = AuthType.OAuthGoogle;
      _user = User(
        id: user.id,
        email: user.email,
        displayName: user.displayName,
        photoUrl: user.photoUrl,
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> persistUserData(dynamic user) async {
    
  }

  Future<void> signOut() async {
    _user = null;
    _type = null;

    try {
      switch (_type) {
        case AuthType.OAuthGoogle:
          await _googleSignIn.signOut();
          break;
        case AuthType.Email:
          // TODO: Handle this case.
          break;
        case AuthType.OAuthFacebook:
          // TODO: Handle this case.
          break;
        default:
          return;
      }
      _firebaseAuth.signOut();
    } catch (error) {}
  }
}
