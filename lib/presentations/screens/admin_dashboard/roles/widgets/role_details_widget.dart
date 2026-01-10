import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../controller/bloc/employees_managements/roles/role_details_bloc.dart';
import '../../../../controller/bloc/employees_managements/roles/roles_bloc.dart';
import '../../../../controller/cubit/employees_management/roles/edit_permissions_cubit.dart';
import 'edit_permissions_dialog.dart';

class RoleDetailsWidget extends StatelessWidget {
  const RoleDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<RolesBloc, RolesState>(
      listenWhen: (previous, current) => current is RoleDeleteSuccess,
      listener: (context, state) => context.read<RoleDetailsBloc>().add(ClearRoleDetailsEvent()),
      child: BlocBuilder<RoleDetailsBloc, RoleDetailsState>(
        builder: (context, state) {
          if (state is RoleDetailsInitial) return const _EmptyState();
          if (state is RoleDetailsLoading) return const Center(child: CircularProgressIndicator(color: AppColors.c6));
          if (state is RoleDetailsFailed) return Center(child: Text(state.message, style: const TextStyle(color: Colors.redAccent)));

          if (state is RoleDetailsLoaded) {
            final role = state.role.data!;
            final permissions = role.permissions ?? [];

            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: AppColors.c5,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                  role.name ?? '',
                                  style: const TextStyle(color: AppColors.c1, fontSize: 20, fontWeight: FontWeight.bold)
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 22),
                              onPressed: () => _showDeleteDialog(context, roleId: role.id!, roleName: role.name ?? ''),
                            ),
                            const SizedBox(width: 30),
                          ],
                        ),
                        Text('id: ${role.id}', style: const TextStyle(color: AppColors.c1,  fontSize: 12)),
                        const Divider(height: 32, color: AppColors.c4, thickness: 1),
                        const Text('الصلاحيات المتاحة', style: TextStyle(color: AppColors.c1, fontWeight: FontWeight.bold, fontSize: 16)), // تكبير عنوان القسم قليلاً
                        const SizedBox(height: 16), // زيادة المسافة تحت العنوان
                        if (permissions.isEmpty)
                          const Text('لا توجد صلاحيات معينة لهذا الدور', style: TextStyle(color: AppColors.c6)),

                        // 💡 تم تعديل الـ Wrap والـ Chip لتكبير الخط
                        Wrap(
                          spacing: 10, // زيادة المسافة الأفقية لتناسب الخط الأكبر
                          runSpacing: 10, // زيادة المسافة الرأسية
                          children: permissions.map((p) => Chip(
                            label: Text(
                              p.name ?? '',
                              style: const TextStyle(
                                color: AppColors.c1,
                                fontSize: 14, // ⬅️ تكبير الخط من 11 إلى 14
                                fontWeight: FontWeight.w500, // زيادة سماكة الخط للوضوح
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // زيادة الحشو الداخلي
                            backgroundColor: AppColors.c4,
                            side: BorderSide(color: AppColors.c1.withOpacity(0.2)),
                          )).toList(),
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.c1,
                              foregroundColor: AppColors.c3,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              elevation: 0,
                            ),
                            icon: const Icon(Icons.edit_outlined, size: 18),
                            label: const Text('تعديل صلاحيات الوصول', style: TextStyle(fontWeight: FontWeight.bold)),
                            onPressed: () {
                              final initialIds = role.permissions?.where((e) => e.id != null).map((e) => e.id!).toSet() ?? {};
                              showDialog(
                                context: context,
                                builder: (_) => MultiBlocProvider(
                                  providers: [
                                    BlocProvider.value(value: context.read<RoleDetailsBloc>()),
                                    BlocProvider(create: (_) => EditPermissionsCubit(initialSelectedIds: initialIds)),
                                  ],
                                  child: EditPermissionsDialog(role: role, allPermissions: state.allPermissions),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: IconButton(
                      icon: const Icon(Icons.close, size: 18, color: AppColors.c1),
                      onPressed: () => context.read<RoleDetailsBloc>().add(ClearRoleDetailsEvent()),
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, {required int roleId, required String roleName}) {
    final rolesBloc = context.read<RolesBloc>();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.c4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('حذف الدور', style: TextStyle(color: AppColors.c1)),
        content: Text('هل أنت متأكد من حذف الدور "$roleName"؟', style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('إلغاء', style: TextStyle(color: AppColors.c6))
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              rolesBloc.add(DeleteRoleEvent(roleId));
              Navigator.pop(dialogContext);
            },
            child: const Text('تأكيد الحذف', style: TextStyle(color: AppColors.white)),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();
  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.c5,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.touch_app_outlined, color: AppColors.c1, size: 40),
              SizedBox(height: 16),
              Text(
                  'اختر دوراً من القائمة لعرض التفاصيل',
                  style: TextStyle(color: AppColors.c1)
              ),
            ],
          ),
        ),
      ),
    );
  }
}