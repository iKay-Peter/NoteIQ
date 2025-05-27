abstract class AppException implements Exception {
  final String message;
  const AppException(this.message);
}

class NetworkException extends AppException {
  const NetworkException([super.message = 'No internet connection']);

  @override
  String toString() => 'Network Exception: $message';
}

class ServerConnectionException extends AppException {
  const ServerConnectionException([
    super.message = 'Unable to connect to the server',
  ]);

  @override
  String toString() => 'Server Connection Exception: $message';
}

class SSLException extends AppException {
  const SSLException([
    super.message = 'SSL Error - Unable to connect to the server',
  ]);

  @override
  String toString() => 'Server Connection Exception: $message';
}

class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'Unauthorized']);

  @override
  String toString() => 'Unauthorized Exception: $message';
}

class NotConfirmedException extends AppException {
  const NotConfirmedException([super.message = 'Account not confirmed']);

  @override
  String toString() => 'Not Confirmed Exception: $message';
}

class UnknownException extends AppException {
  const UnknownException([super.message = 'Unknown error occurred']);

  @override
  String toString() => 'Unknown Exception: $message';
}
