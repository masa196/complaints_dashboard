// lib/presentations/screens/admin_dashboard/admin_panel_app.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/presentations/screens/admin_dashboard/roles/roles_management_page.dart';
import '../../controller/bloc/admin_complaints/admin_complaints_bloc.dart';
import '../../controller/bloc/audit_logs/audit_bloc.dart';
import '../../controller/bloc/employees_managements/create_employee/create_email_bloc.dart';
import '../../controller/bloc/employees_managements/create_employee/create_email_event.dart';
import '../../controller/bloc/employees_managements/employees/employees_bloc.dart';
import '../../controller/bloc/employees_managements/roles/role_details_bloc.dart';
import '../../controller/bloc/government_agencies/gov_agencies_bloc.dart';
import '../../controller/bloc/statistics/statistics_bloc.dart';
import '../../controller/bloc/employees_managements/roles/roles_bloc.dart';
import '../../controller/cubit/admin_navigation_cubit.dart';
import '../../../core/constants/app_colors.dart';
import '../../controller/cubit/employees_management/create_employees/create_email_cubit.dart';
import 'admin_sidepar.dart';
import 'audit_logs/audit_logs_page.dart';
import 'complaints_admin/admin_complaints_page.dart';
import 'employees_management/create_employee_screen.dart';
import 'employees_management/employees_page.dart';
import 'statistics/statistics_page.dart';

class AdminPanelApp extends StatelessWidget {
  const AdminPanelApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminNavigationCubit(),
      child: Directionality(
        // 💡 تفعيل اتجاه اليمين إلى اليسار للتطبيق بالكامل
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppColors.c4,
          body: SafeArea(
            child: Row(
              children: [
                // 💡 الـ Sidebar سيكون في اليمين تلقائياً لأن ترتيبه الأول في الـ Row مع RTL
                const AdminSidebar(),
                VerticalDivider(
                  width: 1,           // المساحة التي يشغلها العنصر
                  thickness: 5,       // سمك الخط نفسه
                  color: const Color(0x805A8F76), // لون الخط (نفس لون حدود البطاقات لديك مع شفافية)
                ),

                // 💡 المحتوى سيكون في اليسار
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
                            context.read<RolesBloc>().add(FetchRolesEvent());
                            context.read<RoleDetailsBloc>().add(ClearRoleDetailsEvent());
                            return RolesManagementPage(key: uniqueKey);
                          case AdminPage.employeesList:
                            context.read<EmployeesBloc>().add(const FetchEmployees(1));
                            return EmployeesPage(key: uniqueKey);
                          case AdminPage.auditLogs:
                            context.read<AuditBloc>().add(const FetchAuditLogsEvent(1));
                            return AuditLogsPage(key: uniqueKey);
                          case AdminPage.complaintsShow:
                            context.read<AdminComplaintsBloc>().add(const FetchAdminComplaintsEvent());
                            return AdminComplaintsPage(key: uniqueKey);
                          case AdminPage.createEmployee:
                            context.read<CreateEmailCubit>().clearAll();
                            context.read<CreateEmailBloc>().add(ResetCreateEmailEvent());
                            context.read<GovAgenciesBloc>().add(FetchGovAgenciesEvent());

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
      ),
    );
  }
}