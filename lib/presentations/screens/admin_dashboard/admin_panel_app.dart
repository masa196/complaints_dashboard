import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/presentations/screens/admin_dashboard/roles/roles_management_page.dart';
import '../../controller/bloc/employees_managements/employees/employees_bloc.dart';
import '../../controller/cubit/admin_navigation_cubit.dart';
import '../../controller/cubit/employees_management/create_employees/create_email_cubit.dart';
import '../../../core/constants/app_colors.dart';
import 'admin_sidepar.dart';
import 'employees_management/create_employee_screen.dart';
import 'employees_management/employees_page.dart';



class AdminPanelApp extends StatelessWidget {
  const AdminPanelApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminNavigationCubit(),
      child: Scaffold(
        backgroundColor: AppColors.c4,
        body: SafeArea(
          child: Row(
            children: [
              const AdminSidebar(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: BlocBuilder<AdminNavigationCubit, AdminPage>(
                    builder: (context, page) {
                      switch (page) {
                        case AdminPage.rolesManagement:
                          return const RolesManagementPage();

                        case AdminPage.employeesList:
                          context.read<EmployeesBloc>().add(const FetchEmployees(1));
                          return EmployeesPage();

                        case AdminPage.createEmployee:
                        default:
                          return Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 700),
                              child: const EmployeeFormCard(),
                            ),
                          );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


