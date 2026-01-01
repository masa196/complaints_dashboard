// lib/auth_admin/presentations/screens/roles/roles_management_page.dart
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../presentations/screens/admin_dashboard/admin_panel_app.dart';
import 'widgets/role_details_widget.dart';
import 'widgets/roles_list_widget.dart';

class RolesManagementPage extends StatelessWidget {
  const RolesManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height - 32,
        ),
        decoration: BoxDecoration(
          color: AppColors.backGround,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Roles & Permissions',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Manage system roles and control access permissions',
            ),
            SizedBox(height: 16),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(flex: 2, child: RolesListWidget()),
                SizedBox(width: 16),
                Flexible(flex: 3, child: RoleDetailsWidget()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
