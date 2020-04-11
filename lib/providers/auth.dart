import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:justclass/models/user.dart';
import 'package:justclass/utils/api_call.dart';

enum AuthType { FirebaseEmailPassword, OAuthGoogle, OAuthFacebook }

extension AuthTypeMethod on AuthType {
  String get name {
    switch (this) {
      case AuthType.FirebaseEmailPassword:
        return "Email and Password";
      case AuthType.OAuthGoogle:
        return "Google Account";
      case AuthType.OAuthFacebook:
        return "Facebook Account";
      default:
        return "";
    }
  }
}

class Auth with ChangeNotifier {
  final _googleSignIn = GoogleSignIn(scopes: ['email']);
  User currentUser;
  AuthType _type;


  AuthType get authType => _type;

  Future<void> signInGoogle() async {
    try {
      print(_type.name);
      final user = await _googleSignIn.signIn();
      if (user == null) return Future.value();

      _type = AuthType.OAuthGoogle;
      await _storeUserData(user);

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> _storeUserData(dynamic anyUser) async {
    ;
    switch (_type) {
      case AuthType.OAuthGoogle:
        final user = anyUser as GoogleSignInAccount;
        currentUser = User(
          id: user.id,
          email: user.email,
          displayName: user.displayName,
          photoUrl: user.photoUrl,
        );
        break;
      case AuthType.FirebaseEmailPassword:
        // TODO: Handle this case.
        break;
      case AuthType.OAuthFacebook:
        // TODO: Handle this case.
        break;
    }
    await ApiCall.postUserData(currentUser);
  }

  Future<void> signOut() async {
    try {
      switch (_type) {
        case AuthType.OAuthGoogle:
          await _googleSignIn.signOut();
          break;
        case AuthType.FirebaseEmailPassword:
          // TODO: Handle this case.
          break;
        case AuthType.OAuthFacebook:
          // TODO: Handle this case.
          break;
        default:
          return;
      }
    } finally {
      currentUser = null;
      _type = null;
      notifyListeners();
    }
  }
}
