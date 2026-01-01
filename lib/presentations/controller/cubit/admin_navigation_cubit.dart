import 'package:flutter_bloc/flutter_bloc.dart';

enum AdminPage {
  createEmployee,
  rolesManagement,
}

class AdminNavigationCubit extends Cubit<AdminPage> {
  AdminNavigationCubit() : super(AdminPage.createEmployee);

  void goToCreateEmployee() => emit(AdminPage.createEmployee);
  void goToRolesManagement() => emit(AdminPage.rolesManagement);
}
