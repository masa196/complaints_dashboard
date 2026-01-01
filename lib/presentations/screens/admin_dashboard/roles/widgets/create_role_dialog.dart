import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../controller/bloc/employees_managements/roles/roles_bloc.dart';
import '../../../../controller/cubit/employees_management/roles/create_role_cubit.dart';
import '../../../../widgets/custom_snack_bar.dart';




class CreateRoleDialog extends StatelessWidget {
  const CreateRoleDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Create Role'),
      content: SizedBox(
        width: 450,
        child: BlocBuilder<CreateRoleCubit, CreateRoleState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Role Name
                  TextField(
                    decoration: const InputDecoration(labelText: 'Role Name'),
                    onChanged: context.read<CreateRoleCubit>().updateName,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Permissions',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: state.allPermissions.map((perm) {
                      final selected = state.entity.permissions.contains(perm);
                      return FilterChip(
                        label: Text(perm),
                        selected: selected,
                        onSelected: (_) {
                          context.read<CreateRoleCubit>().togglePermission(perm);
                        },
                        selectedColor: AppColors.c1,
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        BlocBuilder<CreateRoleCubit, CreateRoleState>(
          builder: (context, state) {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.c1),
              onPressed: state.isValid
                  ? () {
                final bloc = context.read<RolesBloc>();
                final entity = state.entity;

                bloc.add(CreateRoleEvent(entity));

                // الاستماع مباشرة لأحداث الـ Bloc
                bloc.stream.firstWhere(
                      (s) => s is RoleCreateSuccess || s is RolesFailed,
                ).then((s) {
                  if (s is RoleCreateSuccess) {
                    CustomSnackBar.show(
                      context,
                      title: 'Success',
                      message: 'Role created successfully',
                      contentType: ContentType.success,
                    );
                    Navigator.pop(context);
                  } else if (s is RolesFailed) {
                    CustomSnackBar.show(
                      context,
                      title: 'Error',
                      message: s.message,
                      contentType: ContentType.failure,
                    );
                  }
                });
              }
                  : null,
              child: const Text(
                'Create',
                style: TextStyle(color: AppColors.white),
              ),
            );
          },
        ),
      ],
    );
  }
}
