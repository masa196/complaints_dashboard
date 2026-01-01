import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../controller/bloc/auth/auth_bloc.dart';

class EmployeeSidebar extends StatelessWidget {
  final void Function(BuildContext context) confirmLogout;
  const EmployeeSidebar({Key? key, required this.confirmLogout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const accent = AppColors.c5;
    const textPrimary = AppColors.c1;
    const textSecondary = AppColors.c6;
    const sidebarBg = AppColors.c4;

    return Container(
      width: 260,
      color: sidebarBg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: const EdgeInsets.all(24.0), child: Row(children: [
            Container(width: 48, height: 48, decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.person, color: textPrimary)),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
              Text('لوحة الموظف', style: TextStyle(color: textPrimary, fontSize: 16)),
              SizedBox(height: 4),
              Text('حساب الموظف', style: TextStyle(color: textSecondary, fontSize: 12)),
            ])
          ])),
          _buildSidebarItem(icon: Icons.list, title: 'الشكاوي', color: textSecondary, onTap: () {}),
          const Spacer(),
          BlocBuilder<AuthBloc, AuthState>(builder: (context, authState) {
            final isLoading = authState is AuthLoading;
            return _buildSidebarItem(icon: Icons.logout, title: 'تسجيل الخروج', color: Colors.redAccent, onTap: isLoading ? () {} : () => confirmLogout(context));
          }),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSidebarItem({required IconData icon, required String title, required Color color, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(10), border: Border.all(color: color.withOpacity(0.3))),
          child: Row(children: [Icon(icon, color: color), const SizedBox(width: 8), Text(title, style: TextStyle(color: color, fontSize: 14))]),
        ),
      ),
    );
  }
}