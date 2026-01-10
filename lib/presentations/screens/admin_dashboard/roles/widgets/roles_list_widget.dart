import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../controller/bloc/employees_managements/roles/role_details_bloc.dart';
import '../../../../controller/bloc/employees_managements/roles/roles_bloc.dart';
import '../../../../controller/cubit/employees_management/roles/create_role_cubit.dart';
import '../../../../widgets/custom_snack_bar.dart';
import 'create_role_dialog.dart';

class RolesListWidget extends StatelessWidget {
  const RolesListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<RolesBloc, RolesState>(
      listener: (context, state) {
        if (state is RolesFailed) {
          CustomSnackBar.show(context, title: 'خطأ', message: state.message, contentType: ContentType.failure);
        } else if (state is RoleDeleteSuccess) {
          CustomSnackBar.show(context, title: 'نجاح', message: 'تم حذف الدور بنجاح', contentType: ContentType.success);
        } else if (state is RoleCreateSuccess) {
          CustomSnackBar.show(context, title: 'نجاح', message: 'تم إنشاء الدور بنجاح', contentType: ContentType.success);
        }
      },
      child: Card(
        elevation: 2,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: AppColors.c5, // 💡 لون أفتح قليلاً من c3
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'الأدوار المتاحة',
                    style: TextStyle(color: AppColors.c1, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, color: AppColors.c4,size: 30,),
                    onPressed: () async {
                      final roleDetailsBloc = context.read<RoleDetailsBloc>();
                      final permissionsResult = await roleDetailsBloc.getAllPermissions();
                      permissionsResult.fold(
                            (failure) => CustomSnackBar.show(context, title: 'خطأ', message: failure.message, contentType: ContentType.failure),
                            (allPermissions) {
                          final permissionsList = allPermissions.data?.map((p) => p.name!).toList() ?? [];
                          showDialog(
                            context: context,
                            builder: (_) => MultiBlocProvider(
                              providers: [
                                BlocProvider.value(value: context.read<RolesBloc>()),
                                BlocProvider(create: (_) => CreateRoleCubit(permissionsList)),
                              ],
                              child: const CreateRoleDialog(),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
              const Divider(color: AppColors.c4, thickness: 1),
              SizedBox(
                height: 400,
                child: BlocBuilder<RolesBloc, RolesState>(
                  buildWhen: (previous, current) => current is RolesLoading || current is RolesLoaded || current is RolesFailed,
                  builder: (context, state) {
                    if (state is RolesLoading) return const Center(child: CircularProgressIndicator(color: AppColors.c6));
                    if (state is RolesLoaded) {
                      if (state.roles.isEmpty) return const Center(child: Text('لا توجد أدوار', style: TextStyle(color: AppColors.c6)));
                      return ListView.separated(
                        itemCount: state.roles.length,
                        separatorBuilder: (_, __) => Divider(color: AppColors.c4, height: 1),
                        itemBuilder: (context, index) {
                          final role = state.roles[index];
                          return Theme(
                            data: Theme.of(context).copyWith(
                              // 💡 تغيير لون الـ Hover ليكون متناسقاً (أخضر فاتح شفاف جداً)
                              hoverColor: AppColors.c6.withOpacity(0.15),
                              // 💡 جعل تأثير الضغطة (Splash) متناسقاً مع اللون الذهبي
                              splashColor: AppColors.c1.withOpacity(0.1),
                              highlightColor: Colors.transparent,
                            ),
                            child: ListTile(
                              title: Text(role.name ?? '', style: const TextStyle(color: AppColors.c1)),
                              subtitle: Text('ID: ${role.id}', style: const TextStyle(color: AppColors.c6, fontSize: 11)),
                              trailing: const Icon(Icons.arrow_back_ios_new, color: AppColors.c4, size: 14),
                              onTap: () => context.read<RoleDetailsBloc>().add(FetchRoleDetailsEvent(role.id!)),
                            ),
                          );
                        },
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}