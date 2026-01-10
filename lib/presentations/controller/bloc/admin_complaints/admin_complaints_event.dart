part of 'admin_complaints_bloc.dart';

abstract class AdminComplaintsEvent extends Equatable {
  const AdminComplaintsEvent();
  @override
  List<Object?> get props => [];
}

class FetchAdminComplaintsEvent extends AdminComplaintsEvent {
  final String? status;
  const FetchAdminComplaintsEvent({this.status});

  @override
  List<Object?> get props => [status];
}
