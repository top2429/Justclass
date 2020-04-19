class HttpException implements Exception {
  final String message;

  HttpException({this.message = 'Something went wrong!'});

  @override
  String toString() => message;
}
