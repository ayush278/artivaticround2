import '../helpers/constants.dart';

class APIException implements Exception {
  final _message;
  final _prefix;
  APIException([this._message, this._prefix]);
  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends APIException {
  FetchDataException([String? message])
      : super(message, COMMUNICATION_ERROR_MESSAGE);
}

class BadRequestException extends APIException {
  BadRequestException([message]) : super(message, INVALID_REQUEST_MESSAGE);
}

class UnauthorisedException extends APIException {
  UnauthorisedException([message]) : super(message, UNAUTHORISED_MESSAGE);
}

class InvalidInputException extends APIException {
  InvalidInputException([String? message])
      : super(message, INVALID_INPUT_MESSAGE);
}
