import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/employees/assign_remove_role_entity.dart';
import '../../../controller/bloc/employees_managements/employees/employees_bloc.dart';
import '../../../controller/bloc/employees_managements/roles/roles_bloc.dart';
import '../../../controller/cubit/employees_management/roles/roles_cubit.dart';

class RolesDialog extends StatefulWidget {
  final int userId;
  final List<String> currentRoles;

  const RolesDialog({
    super.key,
    required this.userId,
    required this.currentRoles,
  });

  @override
  State<RolesDialog> createState() => _RolesDialogState();
}

class _RolesDialogState extends State<RolesDialog> {
  bool isAdding = true;

  @override
  void initState() {
    super.initState();
    context.read<RolesCubit>().setRoles(widget.currentRoles);
  }

  @override
  Widget build(BuildContext context) {
    // تخزين المراجع قبل العمليات الـ async
    final employeesBloc = context.read<EmployeesBloc>();
    final rolesBloc = context.read<RolesBloc>();

    return AlertDialog(
      title: Text(isAdding ? 'إضافة دور للموظف' : 'حذف دور من الموظف'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ChoiceChip(
                label: const Text('إضافة'),
                selected: isAdding,
                onSelected: (selected) {
                  setState(() => isAdding = true);
                  context.read<RolesCubit>().clearRoles();
                },
              ),
              const SizedBox(width: 10),
              ChoiceChip(
                label: const Text('حذف'),
                selected: !isAdding,
                onSelected: (selected) {
                  setState(() => isAdding = false);
                  context.read<RolesCubit>().clearRoles();
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          BlocBuilder<RolesBloc, RolesState>(
            builder: (context, state) {
              if (state is RolesLoading) return const CircularProgressIndicator();
              if (state is RolesLoaded) {
                final rolesList = isAdding
                    ? state.roles.where((r) => !widget.currentRoles.contains(r.name)).toList()
                    : state.roles.where((r) => widget.currentRoles.contains(r.name)).toList();

                if (rolesList.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(isAdding ? 'لا توجد أدوار إضافية متاح إضافتها' : 'لا توجد أدوار لحذفها'),
                  );
                }

                return BlocBuilder<RolesCubit, RolesCubitState>(
                  builder: (context, cubitState) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: rolesList.map((role) {
                        return RadioListTile<String>(
                          title: Text(role.name!),
                          value: role.name!,
                          groupValue: cubitState.selectedRoles.isNotEmpty ? cubitState.selectedRoles.first : null,
                          onChanged: cubitState.isLoading
                              ? null
                              : (value) {
                            context.read<RolesCubit>().addRole(value!);
                          },
                        );
                      }).toList(),
                    );
                  },
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        BlocBuilder<RolesCubit, RolesCubitState>(
          builder: (context, cubitState) {
            return ElevatedButton(
              onPressed: cubitState.selectedRoles.isEmpty || cubitState.isLoading
                  ? null
                  : () async {
                context.read<RolesCubit>().setLoading(true);
                final selectedRole = cubitState.selectedRoles.first;

                try {
                  if (isAdding) {
                    await rolesBloc.assignRoleUseCase(
                      AssignRemoveRoleEntity(employeeId: widget.userId, role: selectedRole),
                    );
                  } else {
                    await rolesBloc.removeRoleUseCase(
                      AssignRemoveRoleEntity(employeeId: widget.userId, role: selectedRole),
                    );
                  }

                  // **الخطوة الأهم: تحديث جدول الموظفين**
                  employeesBloc.add(RefreshEmployees());

                  // تحديث قائمة الأدوار العامة إذا لزم الأمر
                  rolesBloc.add(FetchRolesEvent());

                  if (mounted) Navigator.pop(context);
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('خطأ: $e')),
                    );
                  }
                } finally {
                  if (mounted) context.read<RolesCubit>().setLoading(false);
                }
              },
              child: cubitState.isLoading
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Text(isAdding ? 'تأكيد الإضافة' : 'تأكيد الحذف'),
            );
          },
        ),
      ],
    );
  }
}