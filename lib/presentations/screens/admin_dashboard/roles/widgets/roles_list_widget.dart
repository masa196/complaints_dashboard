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
    return Card(
      elevation: 3,
      shadowColor: AppColors.blackShadow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Roles',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: AppColors.c4),
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: AppColors.c4),
                  onPressed: () async {
                    final roleDetailsBloc = context.read<RoleDetailsBloc>();
                    final permissionsResult =
                    await roleDetailsBloc.getAllPermissions();

                    permissionsResult.fold(
                          (failure) {
                        CustomSnackBar.show(
                          context,
                          title: 'Error',
                          message: failure.message,
                          contentType: ContentType.failure,
                        );
                      },
                          (allPermissions) {
                        final permissionsList =
                            allPermissions.data?.map((p) => p.name!).toList() ??
                                [];

                        showDialog(
                          context: context,
                          builder: (_) => MultiBlocProvider(
                            providers: [
                              BlocProvider.value(
                                  value: context.read<RolesBloc>()),
                              BlocProvider(
                                  create: (_) =>
                                      CreateRoleCubit(permissionsList)),
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
            const SizedBox(height: 12),
            SizedBox(
              height: 400, // لتجنب Expanded داخل ScrollView
              child: BlocBuilder<RolesBloc, RolesState>(
                builder: (context, state) {
                  if (state is RolesLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is RolesFailed) {
                    return Center(child: Text(state.message));
                  }
                  if (state is RolesLoaded) {
                    return ListView.separated(
                      itemCount: state.roles.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final role = state.roles[index];
                        return ListTile(
                          title: Text(role.name ?? ''),
                          subtitle: Text('ID: ${role.id}'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            context
                                .read<RoleDetailsBloc>()
                                .add(FetchRoleDetailsEvent(role.id!));
                          },
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
    );
  }
}
