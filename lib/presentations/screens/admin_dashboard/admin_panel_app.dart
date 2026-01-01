import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth_admin/presentations/screens/roles/roles_management_page.dart';
import '../../controller/bloc/auth/auth_bloc.dart';
import '../../controller/cubit/admin_navigation_cubit.dart';
import '../../controller/cubit/employees_management/create_employees/create_email_cubit.dart';
import 'create_employee_screen.dart';
import '../../../core/constants/app_colors.dart';


/// لوحة تحكم الأدمن الرئيسية
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
              const AdminSidebar(), // Sidebar ثابت
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: BlocBuilder<AdminNavigationCubit, AdminPage>(
                    builder: (context, page) {
                      switch (page) {
                        case AdminPage.rolesManagement:
                          return const RolesManagementPage();
                        case AdminPage.createEmployee:
                        default:
                          return Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 700),
                              child: BlocProvider<CreateEmailCubit>.value(
                                value: context.read<CreateEmailCubit>(),
                                child: const EmployeeFormCard(),
                              ),
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

/// Sidebar ثابت لجميع صفحات لوحة الأدمن
class AdminSidebar extends StatelessWidget {
  const AdminSidebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF5A8F76);
    const textPrimary = Color(0xFFEEE8B2);
    const textSecondary = Color(0xFF96CD80);
    const sidebarBg = Color(0xFF203B37);

    final navigationCubit = context.read<AdminNavigationCubit>();

    return Container(
      width: 260,
      color: sidebarBg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.shield, color: textPrimary),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Admin Panel',
                        style: TextStyle(color: textPrimary, fontSize: 16)),
                    SizedBox(height: 4),
                    Text('System Control',
                        style: TextStyle(color: textSecondary, fontSize: 12)),
                  ],
                )
              ],
            ),
          ),
          _buildSidebarItem(
            icon: Icons.person_add,
            title: 'إنشاء حساب',
            color: textSecondary,
            onTap: navigationCubit.goToCreateEmployee,
          ),
          _buildSidebarItem(
            icon: Icons.security,
            title: 'إدارة الصلاحيات',
            color: textSecondary,
            onTap: navigationCubit.goToRolesManagement,
          ),
          const Spacer(),
          BlocListener<AuthBloc, AuthState>(
            listenWhen: (prev, curr) =>
            curr is AuthUnauthenticated || curr is AuthFailure,
            listener: (context, state) {
              if (state is AuthFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
              if (state is AuthUnauthenticated) {
                Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
              }
            },
            child: _buildSidebarItem(
              icon: Icons.logout,
              title: 'تسجيل الخروج',
              color: Colors.redAccent,
              onTap: () {
                context.read<AuthBloc>().add(LogoutRequested());
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSidebarItem({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Text(title, style: TextStyle(color: color, fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}
