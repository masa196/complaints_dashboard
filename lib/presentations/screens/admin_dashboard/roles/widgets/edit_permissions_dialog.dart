import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../data/models/permissions/all_permissions_model.dart';
import '../../../../../data/models/roles/role_model.dart';
import '../../../../controller/bloc/employees_managements/roles/role_details_bloc.dart';
import '../../../../controller/cubit/employees_management/roles/edit_permissions_cubit.dart';


// ======================= edit_permissions_dialog.dart =======================
class EditPermissionsDialog extends StatelessWidget {
  final RoleDetails role;
  final List<DatumPer> allPermissions;

  const EditPermissionsDialog({
    super.key,
    required this.role,
    required this.allPermissions,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Edit Permissions'),
      content: SizedBox(
        width: 420,
        child: BlocBuilder<EditPermissionsCubit, EditPermissionsState>(
          builder: (context, state) {
            return ListView(
              shrinkWrap: true,
              children: allPermissions.map((perm) {
                return CheckboxListTile(
                  activeColor: AppColors.c1,
                  value: state.selectedIds.contains(perm.id),
                  title: Text(perm.name ?? ''),
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (_) {
                    context
                        .read<EditPermissionsCubit>()
                        .toggle(perm.id!);
                  },
                );
              }).toList(),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.c1),
          onPressed: () {
            final selectedIds =
                context.read<EditPermissionsCubit>().state.selectedIds;

            final selectedNames = allPermissions
                .where((p) => selectedIds.contains(p.id))
                .map((p) => p.name!)
                .toList();

            context.read<RoleDetailsBloc>().add(
              UpdateRolePermissionsEvent(
                roleId: role.id!,
                permissions: selectedNames,
              ),
            );

            Navigator.pop(context);
          },
          child: const Text(
            'Save Changes',
            style: TextStyle(color: AppColors.white),
          ),
        ),
      ],
    );
  }
}
