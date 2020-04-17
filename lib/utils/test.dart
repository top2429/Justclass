class Test {
  static Future<void> delay([seconds = 2]) async {
    await Future.delayed(Duration(seconds: seconds));
  }
}
