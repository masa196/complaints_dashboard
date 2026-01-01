// lib/employee_dashboard/presentation/cubit/complaints/complaints_state.dart
import '../../../../domain/entities/compaints/complaint.dart';

enum ComplaintsStatus { initial, loading, success, failure }

class ComplaintsState {
  final ComplaintsStatus status;
  final List<Complaint> complaints;
  final String? message;
  final String filterStatus;
  final int currentPage;
  final int lastPage;

  ComplaintsState({
    required this.status,
    this.complaints = const [],
    this.message,
    this.filterStatus = 'all',
    this.currentPage = 1,
    this.lastPage = 1,
  });

  ComplaintsState copyWith({
    ComplaintsStatus? status,
    List<Complaint>? complaints,
    String? message,
    String? filterStatus,
    int? currentPage,
    int? lastPage,
  }) {
    return ComplaintsState(
      status: status ?? this.status,
      complaints: complaints ?? this.complaints,
      message: message ?? this.message,
      filterStatus: filterStatus ?? this.filterStatus,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
    );
  }

  List<Complaint> get filteredComplaints {
    if (filterStatus == 'all') return complaints;
    return complaints
        .where((c) => c.status.toLowerCase() == filterStatus.toLowerCase())
        .toList();
  }
}
