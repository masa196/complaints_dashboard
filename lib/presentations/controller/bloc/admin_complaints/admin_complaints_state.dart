part of 'admin_complaints_bloc.dart';

abstract class AdminComplaintsState extends Equatable {
  const AdminComplaintsState();
  @override
  List<Object?> get props => [];
}

class AdminComplaintsInitial extends AdminComplaintsState {}
class AdminComplaintsLoading extends AdminComplaintsState {}

class AdminComplaintsLoaded extends AdminComplaintsState {
  final List<DatumForAdmin> complaints;
  const AdminComplaintsLoaded(this.complaints);

  @override
  List<Object?> get props => [complaints];
}

class AdminComplaintsError extends AdminComplaintsState {
  final String message;
  const AdminComplaintsError(this.message);

  @override
  List<Object?> get props => [message];
}
