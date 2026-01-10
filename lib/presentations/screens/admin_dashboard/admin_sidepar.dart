// lib/presentations/screens/admin_dashboard/admin_sidebar.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../controller/bloc/auth/auth_bloc.dart';
import '../../controller/cubit/admin_navigation_cubit.dart';

class AdminSidebar extends StatelessWidget {
  const AdminSidebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF5A8F76);
    const textPrimary = Color(0xFFEEE8B2);
    const textSecondary = Color(0xFF96CD80);
    const sidebarBg = Color(0xFF203B37);

    return BlocBuilder<AdminNavigationCubit, AdminNavigationState>(
      builder: (context, state) {
        final navigationCubit = context.read<AdminNavigationCubit>();
        final currentPage = state.currentPage;

        return Container(
          width: 260,
          color: sidebarBg,
          // 💡 ضمان محاذاة محتويات الـ Sidebar لليمين
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    Container(
                      width: 48, height: 48,
                      decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.shield, color: textPrimary),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('لوحة التحكم',
                            style: TextStyle(color: textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
                        Text('نظام الإدارة الأساسي',
                            style: TextStyle(color: textSecondary, fontSize: 12)),
                      ],
                    )
                  ],
                ),
              ),
              _buildSidebarItem(
                icon: Icons.dashboard,
                title: 'الإحصائيات والتقارير',
                color: textSecondary,
                isSelected: currentPage == AdminPage.statistics,
                onTap: navigationCubit.goToStatistics,
              ),
              _buildSidebarItem(
                icon: Icons.person_add,
                title: 'إنشاء حساب موظف',
                color: textSecondary,
                isSelected: currentPage == AdminPage.createEmployee,
                onTap: navigationCubit.goToCreateEmployee,
              ),
              _buildSidebarItem(
                icon: Icons.security,
                title: 'إدارة الصلاحيات',
                color: textSecondary,
                isSelected: currentPage == AdminPage.rolesManagement,
                onTap: navigationCubit.goToRolesManagement,
              ),
              _buildSidebarItem(
                icon: Icons.people_alt_outlined,
                title: 'إدارة الموظفين',
                color: textSecondary,
                isSelected: currentPage == AdminPage.employeesList,
                onTap: navigationCubit.goToEmployeesList,
              ),
              _buildSidebarItem(
                icon: Icons.history_rounded,
                title: 'سجلات التتبع',
                color: textSecondary,
                isSelected: currentPage == AdminPage.auditLogs,
                onTap: navigationCubit.goToAuditLogs,
              ),
              _buildSidebarItem(
                icon: Icons.assignment_late_outlined,
                title: 'عرض الشكاوي',
                color: textSecondary,
                isSelected: currentPage == AdminPage.complaintsShow,
                onTap: navigationCubit.goToComplaintsShow,
              ),
              const Spacer(),
              _buildLogoutButton(context),
              const SizedBox(height: 20),
            ],
          ),

        );
      },
    );
  }

  Widget _buildSidebarItem({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
    required bool isSelected,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
      // 💡 استخدم Material هنا للسماح بتأثيرات الـ InkWell بالظهور
      child: Material(
        color: Colors.transparent, // اجعل الخلفية شفافة
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          // 💡 تغيير لون الـ Hover للون مناسب بدلاً من الأحمر الصريح
          hoverColor: color.withOpacity(0.1),
          splashColor: color.withOpacity(0.2), // تأثير الضغطة
          highlightColor: Colors.transparent,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              // إذا لم يكن مختاراً، اجعل اللون شفافاً تماماً ليظهر لون الـ Hover من الـ InkWell
              color: isSelected ? color.withOpacity(0.2) : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected ? color : Colors.transparent,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isSelected ? Colors.white : color.withOpacity(0.8),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    color: isSelected ? Colors.white : color.withOpacity(0.9),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
        }
      },
      child: _buildSidebarItem(
        icon: Icons.logout,
        title: 'تسجيل الخروج',
        color: Colors.redAccent,
        isSelected: false,
        onTap: () => context.read<AuthBloc>().add(LogoutRequested()),
      ),
    );
  }
}