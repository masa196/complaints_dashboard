import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../data/models/employees/employees_model.dart';
import '../../../../data/models/employees/paginated_employees_model.dart';
import '../../../../domain/entities/employees/update_employee_entity.dart';

import '../../../controller/bloc/employees_managements/employees/employees_bloc.dart';
import '../../../controller/bloc/employees_managements/roles/role_details_bloc.dart';
import '../../../controller/bloc/employees_managements/roles/roles_bloc.dart';
import '../../../controller/cubit/employees_management/roles/roles_cubit.dart';
import '../../../controller/cubit/employees_management/update_employess/update_employee_cubit.dart';

import '../../../widgets/custom_snack_bar.dart';
import 'edit_employee_dialoge.dart';
import 'roles_dialog.dart';

class EmployeesPage extends StatelessWidget {
  EmployeesPage({super.key});

  final ScrollController _verticalController = ScrollController();
  final ScrollController _horizontalController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EmployeesBloc, EmployeesState>(
      listener: _listener,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'إدارة الموظفين',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF203B37)
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'يمكنك إدارة بيانات الموظفين وصلاحياتهم من هنا',
              style: TextStyle( color: Color(0xFFEEE8B2),
                fontSize: 18,
                fontWeight: FontWeight.bold,),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: _buildMainContent(context, state),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMainContent(BuildContext context, EmployeesState state) {
    if (state is EmployeesLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is EmployeesLoaded) {
      return _buildTable(context, state);
    } else if (state is EmployeesFailed) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('خطأ: ${state.message}'),
            ElevatedButton(
              onPressed: () => context.read<EmployeesBloc>().add(const FetchEmployees(1)),
              child: const Text('إعادة المحاولة'),
            )
          ],
        ),
      );
    }
    return const SizedBox();
  }

  // ================= LISTENER =================

  void _listener(BuildContext context, EmployeesState state) {
    if (state is EmployeesFailed) {
      CustomSnackBar.show(
        context,
        title: 'خطأ',
        message: state.message,
        contentType: ContentType.failure,
      );
    }

    if (state is EmployeeUpdateSuccess) {
      CustomSnackBar.show(
        context,
        title: 'نجاح',
        message: state.message,
        contentType: ContentType.success,
      );
    }

    if (state is EmployeeDeleteSuccess) {
      CustomSnackBar.show(
        context,
        title: 'تم الحذف',
        message: state.message,
        contentType: ContentType.success,
      );
    }
  }

  // ================= TABLE =================

  Widget _buildTable(BuildContext context, EmployeesLoaded state) {
    return Column(
      children: [
        Expanded(
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                _tableHeader(),
                Expanded(
                  child: Scrollbar(
                    controller: _verticalController,
                    child: SingleChildScrollView(
                      controller: _verticalController,
                      child: SingleChildScrollView(
                        controller: _horizontalController,
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(minWidth: 950),
                          child: DataTable(
                            headingRowHeight: 0,
                            dataRowHeight: 65,
                            columns: const [
                              DataColumn(label: SizedBox()),
                              DataColumn(label: SizedBox()),
                              DataColumn(label: SizedBox()),
                              DataColumn(label: SizedBox()),
                              DataColumn(label: SizedBox()),
                            ],
                            rows: List.generate(
                              state.data.employees.length,
                                  (index) => _buildUserRow(context, state.data.employees[index], index),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        _pagination(context, state.data),
      ],
    );
  }

  Widget _tableHeader() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF203B37),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 950),
          child: DataTable(
            headingRowHeight: 56,
            headingTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            columns: const [
              DataColumn(label: Text('ID')),
              DataColumn(label: Text('الاسم')),
              DataColumn(label: Text('البريد الإلكتروني')),
              DataColumn(label: Text('الأدوار')),
              DataColumn(label: Center(child: Text('العمليات'))),
            ],
            rows: const [],
          ),
        ),
      ),
    );
  }

  DataRow _buildUserRow(BuildContext context, EmployeeModel employee, int index) {
    return DataRow(
      color: WidgetStateProperty.all(index.isEven ? Colors.grey.shade50 : Colors.white),
      cells: [
        DataCell(Text('#${employee.id}')),
        DataCell(Text(employee.name, style: const TextStyle(fontWeight: FontWeight.w600))),
        DataCell(Text(employee.email)),
        DataCell(_rolesCell(context, employee)),
        DataCell(_actionsCell(context, employee)),
      ],
    );
  }

  Widget _rolesCell(BuildContext context, EmployeeModel employee) {
    if (employee.safeRoles.isEmpty) return const Text('---', style: TextStyle(color: Colors.grey));

    return Wrap(
      spacing: 4,
      children: [
        Chip(
          label: Text(employee.safeRoles.first.name!, style: const TextStyle(fontSize: 12)),
          backgroundColor: AppColors.c5.withOpacity(0.1),
        ),
        if (employee.safeRoles.length > 1)
          ActionChip(
            label: Text('+${employee.safeRoles.length - 1}', style: const TextStyle(fontSize: 12)),
            onPressed: () => _showUserRoles(context, employee),
          ),
      ],
    );
  }

  Widget _actionsCell(BuildContext context, EmployeeModel user) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit_note, color: Colors.blue),
          onPressed: () => _showEditDialog(context, user),
          tooltip: 'تعديل البيانات',
        ),
        IconButton(
          icon: const Icon(Icons.shield_outlined, color: Colors.deepPurple),
          onPressed: () => _openRolesDialog(context, user),
          tooltip: 'إدارة الأدوار',
        ),
        IconButton(
          icon: const Icon(Icons.delete_sweep_outlined, color: Colors.redAccent),
          onPressed: () => _confirmDelete(context, user.id),
          tooltip: 'حذف الموظف',
        ),
      ],
    );
  }

  // ================= DIALOGS =================

  void _openRolesDialog(BuildContext context, EmployeeModel user) {
    showDialog(
      context: context,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<RolesBloc>()),
          BlocProvider.value(value: context.read<EmployeesBloc>()),
          BlocProvider.value(value: context.read<RoleDetailsBloc>()),
          BlocProvider(
            create: (_) => RolesCubit()..setRoles(user.safeRoles.map((e) => e.name!).toList()),
          ),
        ],
        child: RolesDialog(
          userId: user.id,
          currentRoles: user.safeRoles.map((e) => e.name!).toList(),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, EmployeeModel employee) {
    showDialog(
      context: context,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<EmployeesBloc>()),
          BlocProvider(
            create: (_) => UpdateEmployeeCubit()
              ..loadUser(UpdateEmployeeEntity(
                id: employee.id,
                name: employee.name,
                email: employee.email,
              )),
          ),
        ],
        child: const EditEmployeeDialog(),
      ),
    );
  }

  void _confirmDelete(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد من حذف هذا الموظف؟ لا يمكن التراجع عن هذا الإجراء.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(ctx);
              context.read<EmployeesBloc>().add(DeleteEmployee(id));
            },
            child: const Text('حذف الآن', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ================= PAGINATION =================

  Widget _pagination(BuildContext context, PaginatedEmployeesModel data) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: data.currentPage > 1
                ? () => context.read<EmployeesBloc>().add(PreviousPage())
                : null,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.c1.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'صفحة ${data.currentPage} من ${data.lastPage}',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFEEE8B2),
                  ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: data.currentPage < data.lastPage
                ? () => context.read<EmployeesBloc>().add(NextPage())
                : null,
          ),
        ],
      ),
    );
  }

  void _showUserRoles(BuildContext context, EmployeeModel employee) {
    showDialog(
      context: context,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: AppColors.c4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'أدوار الموظف: ${employee.name}',
            style: const TextStyle(color: AppColors.c1, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: SizedBox(
            width: double.minPositive,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: employee.safeRoles.isEmpty
                  ? [const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('لا توجد أدوار مسندة حالياً', style: TextStyle(color: AppColors.c6)),
              )]
                  : employee.safeRoles.map((r) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.verified_user_rounded, color: AppColors.c6),
                title: Text(
                  r.name ?? '',
                  style: const TextStyle(color: AppColors.c1, fontSize: 15),
                ),
              )).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إغلاق', style: TextStyle(color: AppColors.c6, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}