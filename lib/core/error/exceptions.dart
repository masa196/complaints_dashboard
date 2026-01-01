import '../network/error_message_model.dart';

class ServerException implements Exception {
 final ErrorMessageModel errorMessageModel;
 const ServerException({required this.errorMessageModel});

 @override
 String toString() {
  return 'ServerException: ${errorMessageModel.message}';
 }
}
