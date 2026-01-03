// lib/employee_dashboard/presentation/screens/employee_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/di.dart';
import '../../../domain/use_cases/complaints/lock_complaint_usecase.dart';
import '../../../domain/use_cases/complaints/unlock_complaint_usecase.dart';
import '../../../domain/use_cases/complaints/update_status_usecase.dart';
import '../../../domain/use_cases/complaints/request_info_usecase.dart';
import '../../../domain/use_cases/complaints/get_complaints_usecase.dart';
import '../../controller/bloc/auth/auth_bloc.dart';
import '../../controller/bloc/complaint_actions/complaint_actions_bloc.dart';
import '../../controller/cubit/complaints/complaints_cubit.dart';
import '../../controller/cubit/complaints/complaints_state.dart';
import '../../widgets/complaint_card.dart';
import '../../widgets/employee_sidebar.dart';
import '../admin_dashboard/auth/login_screen.dart';

class EmployeeDashboardScreen extends StatelessWidget {
  const EmployeeDashboardScreen({Key? key}) : super(key: key);

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.c1,
        title: const Text("تأكيد تسجيل الخروج"),
        content: const Text("هل أنت متأكد أنك تريد تسجيل الخروج؟"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("إلغاء")),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(LogoutRequested(keepLoggedIn: true));
            },
            child: const Text("نعم، تسجيل الخروج"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final complaintsRepo = AppDependencies.complaintsRepo;
    final getComplaintsUseCase = GetComplaintsUseCase(complaintsRepo);
    final lockUseCase = LockComplaintUseCase(complaintsRepo);
    final unlockUseCase = UnlockComplaintUseCase(complaintsRepo);
    final updateStatusUseCase = UpdateStatusUseCase(complaintsRepo);
    final requestInfoUseCase = RequestInfoUseCase(complaintsRepo);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ComplaintsCubit(useCase: getComplaintsUseCase),
        ),
        BlocProvider(
          create: (_) => ComplaintActionsBloc(
            lockUseCase: lockUseCase,
            unlockUseCase: unlockUseCase,
            updateStatusUseCase: updateStatusUseCase,
            requestInfoUseCase: requestInfoUseCase,
          ),
        ),
      ],
      child: _EmployeeDashboardInner(confirmLogout: _confirmLogout),
    );
  }
}

class _EmployeeDashboardInner extends StatelessWidget {
  final void Function(BuildContext context) confirmLogout;
  const _EmployeeDashboardInner({Key? key, required this.confirmLogout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const List<String> statuses = ['all', 'new', 'in_progress', 'resolved', 'rejected'];

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => LoginScreen()), (r) => false);
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF28534E),
        body: SafeArea(
          child: Row(
            children: [
              EmployeeSidebar(confirmLogout: confirmLogout),
              Container(width: 1, color: Colors.grey.shade400),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          BlocBuilder<ComplaintsCubit, ComplaintsState>(
                            builder: (context, state) {
                              final currentValue = statuses.contains(state.filterStatus) ? state.filterStatus : 'all';
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.c1,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.c1),
                                ),
                                child: DropdownButton<String>(
                                  value: currentValue,
                                  underline: const SizedBox.shrink(),
                                  iconEnabledColor: AppColors.c3,
                                  dropdownColor: AppColors.c1,
                                  style: const TextStyle(color: AppColors.c4, fontWeight: FontWeight.bold),
                                  items: statuses
                                      .map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(color: AppColors.c4))))
                                      .toList(),
                                  onChanged: (value) {
                                    if (value != null) context.read<ComplaintsCubit>().filterComplaints(value);
                                  },
                                ),
                              );
                            },
                          ),
                          const Text('الشكاوي الواردة', style: TextStyle(color: AppColors.c1, fontSize: 28, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: BlocBuilder<ComplaintsCubit, ComplaintsState>(
                          builder: (context, state) {
                            if (state.status == ComplaintsStatus.initial) {
                              Future.microtask(() => context.read<ComplaintsCubit>().loadComplaints());
                              return const Center(child: CircularProgressIndicator());
                            }
                            if (state.status == ComplaintsStatus.loading) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (state.status == ComplaintsStatus.failure) {
                              return Center(child: Text('حدث خطأ: ${state.message}'));
                            }

                            final complaints = state.filteredComplaints;
                            if (complaints.isEmpty) return const Center(child: Text('لا توجد شكاوي'));

                            return Column(
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: complaints.length,
                                    itemBuilder: (context, i) {
                                      final c = complaints[i];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                        child: ComplaintCard(
                                          complaint: c,
                                          onEditStatus: (id, currentStatus) => _onEditOrLock(context, id, currentStatus),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed: state.currentPage > 1 ? () => context.read<ComplaintsCubit>().prevPage() : null,
                                      child: const Text('السابق'),
                                    ),
                                    const SizedBox(width: 16),
                                    Text('صفحة ${state.currentPage} من ${state.lastPage}', style: const TextStyle(color: AppColors.c1)),
                                    const SizedBox(width: 16),
                                    ElevatedButton(
                                      onPressed: state.currentPage < state.lastPage ? () => context.read<ComplaintsCubit>().nextPage() : null,
                                      child: const Text('التالي'),
                                    ),
                                  ],
                                )
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onEditOrLock(BuildContext context, int complaintId, String currentStatus) async {
    final actionsBloc = context.read<ComplaintActionsBloc>();
    final cubit = context.read<ComplaintsCubit>();

    actionsBloc.add(LockComplaintRequested(complaintId));

    final lockResult = await actionsBloc.stream.firstWhere(
          (s) =>
      (s is ComplaintActionSuccess && s.complaintId == complaintId && s.action == ComplaintAction.locked) ||
          (s is ComplaintActionFailure && s.complaintId == complaintId && s.action == ComplaintAction.locking),
    );

    if (lockResult is ComplaintActionFailure) {
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('لا يمكن التعديل على هذه الشكوى الان'),
          content: Text(lockResult.message),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('حسناً'))],
        ),
      );
      return;
    }

    String selectedStatus = currentStatus;
    final TextEditingController requestController = TextEditingController();

    final bool didTriggerAction = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx2, setState) {
          return AlertDialog(
            title: const Text(' تعديل الحالة أو طلب معلومات'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Align(alignment: Alignment.centerRight, child: Text('اختر الحالة', style: TextStyle(fontWeight: FontWeight.bold))),
                  const SizedBox(height: 8),
                  Column(
                    children: [
                      RadioListTile<String>(value: 'new', title: const Text('new'), groupValue: selectedStatus, onChanged: (v) => setState(() => selectedStatus = v!)),
                      RadioListTile<String>(value: 'in_progress', title: const Text('in_progress'), groupValue: selectedStatus, onChanged: (v) => setState(() => selectedStatus = v!)),
                      RadioListTile<String>(value: 'resolved', title: const Text('resolved'), groupValue: selectedStatus, onChanged: (v) => setState(() => selectedStatus = v!)),
                      RadioListTile<String>(value: 'rejected', title: const Text('rejected'), groupValue: selectedStatus, onChanged: (v) => setState(() => selectedStatus = v!)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Align(alignment: Alignment.centerRight, child: Text(' : إذا كنت تريد معلومات إضافية حول الشكوى ', style: TextStyle(fontWeight: FontWeight.bold))),
                  const SizedBox(height: 8),
                  TextField(
                    controller: requestController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'اكتب هنا النص الذي تريد إرساله للمواطن',
                      filled: true,
                      fillColor: AppColors.c1.withOpacity(0.06),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx2, false), child: const Text('إغلاق')),
              TextButton(
                onPressed: () {
                  actionsBloc.add(UpdateStatusRequested(id: complaintId, status: selectedStatus));
                  Navigator.pop(ctx2, true);
                },
                child: const Text('تحديث الحالة'),
              ),
              TextButton(
                onPressed: () {
                  final text = requestController.text.trim();
                  if (text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الرجاء كتابة نص الطلب أولاً')));
                    return;
                  }
                  actionsBloc.add(RequestInfoRequested(id: complaintId, requestText: text));
                  Navigator.pop(ctx2, true);
                },
                child: const Text('إرسال طلب معلومات'),
              ),
            ],
          );
        });
      },
    ).then((v) => v ?? false);

    if (!didTriggerAction) {
      actionsBloc.add(UnlockComplaintRequested(complaintId));
      return;
    }

    await cubit.loadComplaints();
    actionsBloc.add(UnlockComplaintRequested(complaintId));
  }
}
