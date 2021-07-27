class CustomException implements Exception {
  final String _message;
  final String _prefix;

  const CustomException([this._message, this._prefix]);

  String toString() => _message;
  String toDetailedString() => '$_prefix: $_message';
}

class UnauthorizedException extends CustomException {
  UnauthorizedException([message]) : super(message, 'Unauthorized');
}

class NotFoundException extends CustomException {
  NotFoundException([message]) : super(message, 'Not Found');
}

class BadRequestException extends CustomException {
  BadRequestException([message]) : super(message, 'Bad Request');
}