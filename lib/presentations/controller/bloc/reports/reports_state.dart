part of 'reports_bloc.dart';
abstract class ReportsState extends Equatable {
  const ReportsState();
  @override
  List<Object?> get props => [];
}
class ReportsInitial extends ReportsState {}
class ReportsLoading extends ReportsState {
  final String type;
  const ReportsLoading(this.type);
}
class ReportsSuccess extends ReportsState {}
class ReportsError extends ReportsState {
  final String message;
  const ReportsError(this.message);
}