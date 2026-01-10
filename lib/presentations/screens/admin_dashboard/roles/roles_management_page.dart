import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
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
          color: AppColors.c4,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.c5.withOpacity(0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'الأدوار والصلاحيات',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.c1,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'يمكنك إدارة أدوار المستخدمين هنا، وتعيين الصلاحيات أو إنشاء أدوار جديدة للنظام.',
              style: TextStyle(color: AppColors.c6),
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