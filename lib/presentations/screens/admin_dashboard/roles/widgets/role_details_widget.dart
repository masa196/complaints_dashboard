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
    return BlocBuilder<RoleDetailsBloc, RoleDetailsState>(
      builder: (context, state) {
        if (state is RoleDetailsInitial) return const _EmptyState();
        if (state is RoleDetailsLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is RoleDetailsFailed) return Center(child: Text(state.message));

        if (state is RoleDetailsLoaded) {
          final role = state.role.data!;
          final permissions = role.permissions ?? [];

          return Card(
            elevation: 3,
            shadowColor: AppColors.blackShadow,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: AppColors.white,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        role.name ?? '',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(color: AppColors.c4),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _showDeleteDialog(
                            context,
                            roleId: role.id!,
                            roleName: role.name ?? '',
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Role ID: ${role.id}',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.greyText),
                  ),
                  const Divider(height: 32),
                  Text(
                    'Permissions',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: AppColors.blackText),
                  ),
                  const SizedBox(height: 12),
                  if (permissions.isEmpty)
                    const Text('No permissions assigned'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: permissions
                        .map(
                          (p) => Chip(
                        label: Text(
                          p.name ?? '',
                          style: const TextStyle(color: AppColors.white),
                        ),
                        backgroundColor: AppColors.c3,
                      ),
                    )
                        .toList(),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      style:
                      ElevatedButton.styleFrom(backgroundColor: AppColors.c4),
                      icon: const Icon(Icons.edit, color: AppColors.white),
                      label: const Text(
                        'Edit Permissions',
                        style: TextStyle(color: AppColors.white),
                      ),
                      onPressed: () {
                        final initialIds = role.permissions
                            ?.where((e) => e.id != null)
                            .map((e) => e.id!)
                            .toSet() ??
                            {};

                        showDialog(
                          context: context,
                          builder: (_) => MultiBlocProvider(
                            providers: [
                              BlocProvider.value(
                                value: context.read<RoleDetailsBloc>(),
                              ),
                              BlocProvider(
                                create: (_) =>
                                    EditPermissionsCubit(initialSelectedIds: initialIds),
                              ),
                            ],
                            child: EditPermissionsDialog(
                              role: role,
                              allPermissions: state.allPermissions,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  void _showDeleteDialog(
      BuildContext context, {
        required int roleId,
        required String roleName,
      }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Role'),
        content: Text('Are you sure you want to delete "$roleName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              final rolesBloc = context.read<RolesBloc>();
              final detailsBloc = context.read<RoleDetailsBloc>();
              rolesBloc.add(DeleteRoleEvent(roleId));
              detailsBloc.add(ClearRoleDetailsEvent());
              Navigator.pop(context);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.white),
            ),
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
      color: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('Select a roles to view details'),
        ),
      ),
    );
  }
}
