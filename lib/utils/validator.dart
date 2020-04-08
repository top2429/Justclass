class Validator {
  final _emailRegExp =
      RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  String validateEmail(String val) {
    if (val.isEmpty) return "Please provide an email";
    if (!_emailRegExp.hasMatch(val)) return "Invalid email";
    return null;
  }

  String validatePassword(String val) {
    if (val.isEmpty) return "Please provide a password";
    return null;
  }

  String validateConfirm(String val, String pass) {
    if (val.isEmpty) return "Please provide a confirm password";
    if (val != pass) return "Confirm password does not match";
    return null;
  }
}
