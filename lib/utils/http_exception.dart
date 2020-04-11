class HttpException implements Exception {
  final String _message;

  HttpException(this._message);

  @override
  String toString() => _message;
}
