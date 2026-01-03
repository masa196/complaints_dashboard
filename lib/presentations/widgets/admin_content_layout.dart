// lib/auth_admin/presentations/components/admin_content_layout.dart
import 'package:flutter/material.dart';
import '../screens/admin_dashboard/admin_sidepar.dart';




class AdminContentLayout extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const AdminContentLayout({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const AdminSidebar(), // Sidebar ثابت في كل الصفحات
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                child,
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    const textPrimary = Color(0xFFEEE8B2);
    const textSecondary = Color(0xFF96CD80);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                color: textPrimary, fontSize: 28, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text(subtitle, style: const TextStyle(color: textSecondary, fontSize: 14)),
      ],
    );
  }
}
