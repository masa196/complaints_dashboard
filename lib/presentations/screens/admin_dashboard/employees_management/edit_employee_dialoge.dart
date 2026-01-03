import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../controller/bloc/employees_managements/employees/employees_bloc.dart';
import '../../../controller/cubit/employees_management/update_employess/update_employee_cubit.dart';


class EditEmployeeDialog extends StatelessWidget {
  const EditEmployeeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final employeesBloc = context.read<EmployeesBloc>();
    final cubit = context.read<UpdateEmployeeCubit>();

    return BlocListener<EmployeesBloc, EmployeesState>(
      listener: (context, state) {
        if (state is EmployeeUpdateSuccess) Navigator.pop(context);
      },
      child: AlertDialog(
        title: const Text('تعديل معلومات الموظف'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: cubit.state.employeeEntity?.name ?? '',
              onChanged: cubit.nameChanged,
              decoration: InputDecoration(errorText: cubit.state.nameError),
            ),
            TextFormField(
              initialValue: cubit.state.employeeEntity?.email ?? '',
              onChanged: cubit.emailChanged,
              decoration: InputDecoration(errorText: cubit.state.emailError),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (!cubit.validate()) return;
              employeesBloc.add(UpdateEmployeeEvent(cubit.state.employeeEntity!));
            },
            child: const Text('تعديل'),
          ),
        ],
      ),
    );
  }
}