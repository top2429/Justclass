final emailRegExp = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

class EmailPassValidator {
  static String validateEmail(String email) {
    if (email.isEmpty) return "Please provide an email";
    if (!emailRegExp.hasMatch(email)) return "Invalid email";
    return null;
  }

  static String validatePassword(String pass) {
    if (pass.isEmpty) return "Please provide a password";
    if (pass.length < 6) return 'Password must have at least 6 characters!';
    // TODO check password strength
    return null;
  }

  static String validateConfirm(String confirm, String pass) {
    if (confirm.isEmpty) return "Please provide a confirm password";
    if (confirm != pass) return "Confirm password does not match";
    return null;
  }
}

class CreateClassValidator {
  static String validateClassTitle(String name) {
    if (name.isEmpty) return "Please provide a class name";
    return null;
  }
}

class NewNoteValidator {
  static String validateNote(String note) {
    if (note.isEmpty) return "Please provide a note";
    const len = 1;
    if (note.length < len) return "A note needs to contain at least $len ${len == 1 ? "character" : "characters"}";
    // TODO: check string contains only break lines
    return null;
  }
}

class JoinClassValidator {
  static String validateCode(String code) {
    if (code.isEmpty) return "Please provide a note";
    const len = 8;
    if (code.length != len) return "Class code must contain $len ${len == 1 ? "character" : "characters"}";
    return null;
  }
}

class InviteTeacherValidator {
  static String validateEmail(String email) {
    if (!emailRegExp.hasMatch(email)) return "Invalid email";
    return null;
  }
}
