class EmailPassValidator {
  static final _emailRegExp =
      RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  static String validateEmail(String email) {
    if (email.isEmpty) return "Please provide an email";
    if (!_emailRegExp.hasMatch(email)) return "Invalid email";
    return null;
  }

  static String validatePassword(String pass) {
    if (pass.isEmpty) return "Please provide a password";
    // TODO check the number of characters
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
  static String validateClassName(String name) {
    if (name.isEmpty) return "Please provide a class name";
    return null;
  }
}
