import 'package:equatable/equatable.dart';
import 'employees_model.dart';

class PaginatedEmployeesModel extends Equatable {
  final List<EmployeeModel> employees;
  final int currentPage;
  final int lastPage;
  final int total;

  const PaginatedEmployeesModel({
    required this.employees,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  factory PaginatedEmployeesModel.fromJson(Map<String, dynamic> json) {
    return PaginatedEmployeesModel(
      employees: (json['data'] as List)
          .map((e) => EmployeeModel.fromJson(e))
          .toList(),
      currentPage: json['current_page'],
      lastPage: json['last_page'],
      total: json['total'],
    );
  }

  @override
  List<Object?> get props => [employees, currentPage, lastPage, total];
}
