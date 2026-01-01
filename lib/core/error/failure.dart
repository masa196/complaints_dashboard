import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  final int? retryAfterSeconds;
  const ServerFailure(String message, {this.retryAfterSeconds}) : super(message);

  @override
  List<Object?> get props => [message, retryAfterSeconds];
}
