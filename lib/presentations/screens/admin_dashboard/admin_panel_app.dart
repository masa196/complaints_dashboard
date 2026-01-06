// lib/presentations/screens/admin_dashboard/admin_panel_app.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/presentations/screens/admin_dashboard/roles/roles_management_page.dart';
import '../../controller/bloc/employees_managements/employees/employees_bloc.dart';
import '../../controller/bloc/statistics/statistics_bloc.dart';
import '../../controller/cubit/admin_navigation_cubit.dart';
import '../../../core/constants/app_colors.dart';
import 'admin_sidepar.dart';
import 'employees_management/create_employee_screen.dart';
import 'employees_management/employees_page.dart';
import 'statistics/statistics_page.dart';

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
                  child: BlocBuilder<AdminNavigationCubit, AdminNavigationState>(
                    builder: (context, state) {
                      final uniqueKey = ValueKey(state.timestamp.millisecondsSinceEpoch);

                      switch (state.currentPage) {
                        case AdminPage.statistics:
                          context.read<StatisticsBloc>().add(FetchStatisticsEvent());
                          return StatisticsPage(key: uniqueKey);

                        case AdminPage.rolesManagement:
                          return RolesManagementPage(key: uniqueKey);

                        case AdminPage.employeesList:
                          context.read<EmployeesBloc>().add(const FetchEmployees(1));
                          return EmployeesPage(key: uniqueKey);

                        case AdminPage.createEmployee:
                          return Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 700),
                              child: EmployeeFormCard(key: uniqueKey),
                            ),
                          );

                        default:
                          context.read<StatisticsBloc>().add(FetchStatisticsEvent());
                          return StatisticsPage(key: uniqueKey);
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