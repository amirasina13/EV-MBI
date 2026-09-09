//Exception that is thrown when http request call response is not 200

import 'app_exception.dart';

class HttpRequestException implements Exception {}

class RemoteServerException implements Exception {}

class LocalDatabaseException implements Exception {}

class InvalidSessionException extends AppException {
  InvalidSessionException({required String message}) : super(message);
}

class InvalidStatusException extends AppException {
  InvalidStatusException({required String message}) : super(message);
}

class InvalidNetworkException extends AppException {
  InvalidNetworkException({required String message}) : super(message);
}

class MaintenanceException extends AppException {
  final bool isMaintenance;

  MaintenanceException({required this.isMaintenance, required String message})
    : super(message);
}

//Exception that is thrown when Entity to Model conversion is performed
class EntityModelMapperException implements Exception {
  final String? message;

  EntityModelMapperException({required this.message});
}

class EmptyDataException extends AppException {
  EmptyDataException({required String message}) : super(message);
}
