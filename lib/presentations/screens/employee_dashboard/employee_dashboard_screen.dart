
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

  String _resolveAgencyName(int? agencyId) {
    final Map<int, String> agencies = {
      1: "وزارة الصحة",
      2: "وزارة التعليم",
      3: "وزارة النقل",
      4: "وزارة الداخلية",
      5: "وزارة الإسكان",
    };
    return agencies[agencyId] ?? "وزارة غير معروفة";
  }

  @override
  Widget build(BuildContext context) {
    final complaintsRepo = AppDependencies.complaintsRepo;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ComplaintsCubit(useCase: GetComplaintsUseCase(complaintsRepo))),
        BlocProvider(create: (_) => ComplaintActionsBloc(
          lockUseCase: LockComplaintUseCase(complaintsRepo),
          unlockUseCase: UnlockComplaintUseCase(complaintsRepo),
          updateStatusUseCase: UpdateStatusUseCase(complaintsRepo),
          requestInfoUseCase: RequestInfoUseCase(complaintsRepo),
        )),
      ],
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: _EmployeeDashboardInner(confirmLogout: _confirmLogout, resolveAgencyName: _resolveAgencyName),
      ),
    );
  }
}

class _EmployeeDashboardInner extends StatelessWidget {
  final void Function(BuildContext context) confirmLogout;
  final String Function(int?) resolveAgencyName;

  const _EmployeeDashboardInner({
    Key? key,
    required this.confirmLogout,
    required this.resolveAgencyName
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, String> statusMap = {
      'all': 'الكل', 'new': 'جديدة', 'in_progress': 'قيد المعالجة', 'resolved': 'تم الحل', 'rejected': 'مرفوضة',
    };

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (r) => false);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.c4,
        drawer: MediaQuery.of(context).size.width < 900 ? Drawer(child: EmployeeSidebar(confirmLogout: confirmLogout)) : null,
        body: SafeArea(
          child: Row(
            children: [
              if (MediaQuery.of(context).size.width >= 900) ...[
                EmployeeSidebar(confirmLogout: confirmLogout),
                const VerticalDivider(width: 1, color: AppColors.c5, thickness: 0.5),
              ],
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(MediaQuery.of(context).size.width < 600 ? 12 : 24),
                  child: Column(
                    children: [
                      _buildHeaderWithFilter(context, statusMap),
                      const SizedBox(height: 16),
                      Expanded(child: _buildComplaintsContent()),
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

  Widget _buildHeaderWithFilter(BuildContext context, Map<String, String> statusMap) {
    return BlocBuilder<ComplaintsCubit, ComplaintsState>(
      builder: (context, state) {
        int? agencyId;
        if (state.complaints.isNotEmpty) {
          agencyId = state.complaints.first.governmentAgencyId;
        }

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          decoration: BoxDecoration(
            color: AppColors.c1.withOpacity(0.12),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: AppColors.c6.withOpacity(0.4), width: 1.5),
          ),
          child: Row(
            children: [
              if (MediaQuery.of(context).size.width < 900)
                IconButton(
                  icon: const Icon(Icons.menu, color: AppColors.c1),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              const Icon(Icons.account_balance_rounded, color: AppColors.c6, size: 28),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('الجهة المسؤولة:', style: TextStyle(color: AppColors.c1.withOpacity(0.7), fontSize: 11)),
                    Text(
                      resolveAgencyName(agencyId),
                      style: const TextStyle(color: AppColors.c6, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.c1,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: statusMap.containsKey(state.filterStatus) ? state.filterStatus : 'all',
                    icon: const Icon(Icons.filter_list, color: AppColors.c6, size: 20),
                    dropdownColor: AppColors.c1,
                    items: statusMap.entries.map((e) => DropdownMenuItem(
                      value: e.key,
                      child: Text(e.value, style: const TextStyle(color: Colors.black, fontSize: 13)),
                    )).toList(),
                    onChanged: (val) => context.read<ComplaintsCubit>().filterComplaints(val!),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }



  Widget _buildComplaintsContent() {
    return BlocBuilder<ComplaintsCubit, ComplaintsState>(
      builder: (context, state) {
        if ((state.status == ComplaintsStatus.loading || state.status == ComplaintsStatus.initial) && state.complaints.isEmpty) {
          if (state.status == ComplaintsStatus.initial) Future.microtask(() => context.read<ComplaintsCubit>().loadComplaints());
          return const Center(child: CircularProgressIndicator(color: AppColors.c6));
        }

        if (state.status == ComplaintsStatus.failure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.cloud_off_rounded, color: Colors.redAccent, size: 60),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    state.message ?? 'فشل الاتصال بالسيرفر',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => context.read<ComplaintsCubit>().loadComplaints(page: state.currentPage),
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text("إعادة المحاولة"),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.c6, foregroundColor: Colors.black),
                ),
              ],
            ),
          );
        }


        final complaints = state.filteredComplaints;
        if (complaints.isEmpty) return const Center(child: Text('لا توجد شكاوي حالياً', style: TextStyle(color: AppColors.c1)));


        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: complaints.length,
                itemBuilder: (context, i) => Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 900),
                    child: ComplaintCard(
                        complaint: complaints[i],
                        onEditStatus: (id, current) => _onEditOrLock(context, id, current)
                    ),
                  ),
                ),
              ),
            ),
            _buildPagination(context, state),
          ],
        );
      },
    );
  }


  Widget _buildPagination(BuildContext context, ComplaintsState state) {
    if (state.status == ComplaintsStatus.failure) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              onPressed: (state.status != ComplaintsStatus.loading && state.currentPage > 1)
                  ? () => context.read<ComplaintsCubit>().prevPage() : null,
              icon: Icon(Icons.arrow_back_ios, color: state.currentPage > 1 ? AppColors.c1 : Colors.white24, size: 18)
          ),
          Text('${state.currentPage} / ${state.lastPage}', style: const TextStyle(color: AppColors.c1, fontWeight: FontWeight.bold)),
          IconButton(
              onPressed: (state.status != ComplaintsStatus.loading && state.currentPage < state.lastPage)
                  ? () => context.read<ComplaintsCubit>().nextPage() : null,
              icon: Icon(Icons.arrow_forward_ios, color: state.currentPage < state.lastPage ? AppColors.c1 : Colors.white24, size: 18)
          ),
        ],
      ),
    );
  }



  Future<void> _onEditOrLock(BuildContext context, int complaintId, String currentStatus) async {
    final actionsBloc = context.read<ComplaintActionsBloc>();
    final cubit = context.read<ComplaintsCubit>();
    actionsBloc.add(LockComplaintRequested(complaintId));


    final stateResult = await actionsBloc.stream.firstWhere(
            (state) => state is ComplaintActionSuccess || state is ComplaintActionFailure
    );


    if (stateResult is ComplaintActionFailure) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppColors.c4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Row(
            children: [
              Icon(Icons.lock_person_rounded, color: Colors.orangeAccent, size: 28),
              SizedBox(width: 10),
              Text("الشكوى قيد المعالجة", style: TextStyle(color: Colors.white, fontSize: 18)),
            ],
          ),
          content: const Text(
            "عذراً، لا يمكنك تعديل هذه الشكوى حالياً لأن هناك موظفاً آخر يقوم بالعمل عليها.",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("موافق", style: TextStyle(color: AppColors.c6, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
      return;
    }


    String selectedStatus = currentStatus;
    final TextEditingController requestController = TextEditingController();

    final bool? result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx2, setState) => AlertDialog(
          backgroundColor: const Color(0xFF1E3A37),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text('تحديث الحالة / طلب معلومات',
              textAlign: TextAlign.right,
              style: TextStyle(color: Colors.white, fontSize: 18)
          ),
          content: SizedBox(
            width: 450,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Align(alignment: Alignment.centerRight,
                      child: Text('الحالة:', style: TextStyle(color: AppColors.c6, fontWeight: FontWeight.bold))),
                  _buildDarkRadio('new', 'جديدة', selectedStatus, (v) => setState(() => selectedStatus = v!)),
                  _buildDarkRadio('in_progress', 'قيد المعالجة', selectedStatus, (v) => setState(() => selectedStatus = v!)),
                  _buildDarkRadio('resolved', 'تم الحل', selectedStatus, (v) => setState(() => selectedStatus = v!)),
                  _buildDarkRadio('rejected', 'مرفوضة', selectedStatus, (v) => setState(() => selectedStatus = v!)),
                  const Divider(color: Colors.white24, height: 30),
                  const Align(alignment: Alignment.centerRight,
                      child: Text('رسالة للمواطن:', style: TextStyle(color: AppColors.c6, fontWeight: FontWeight.bold))),
                  const SizedBox(height: 10),
                  TextField(
                    controller: requestController,
                    maxLines: 2,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'اكتب التوضيح المطلوب هنا...',
                      hintStyle: const TextStyle(color: Colors.white38),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.05),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false),
                child: const Text('إلغاء', style: TextStyle(color: Colors.white70))),
            ElevatedButton(
              onPressed: () {
                actionsBloc.add(UpdateStatusRequested(id: complaintId, status: selectedStatus));
                Navigator.pop(ctx, true);
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.c6),
              child: const Text('تحديث', style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              onPressed: () {
                if(requestController.text.isNotEmpty) {
                  actionsBloc.add(RequestInfoRequested(id: complaintId, requestText: requestController.text));
                  Navigator.pop(ctx, true);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              child: const Text('إرسال طلب', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );

    if (result == true) await cubit.loadComplaints();
    actionsBloc.add(UnlockComplaintRequested(complaintId));
  }



  Widget _buildDarkRadio(String value, String title, String groupValue, Function(String?) onChanged) {
    return Theme(
      data: ThemeData.dark(),
      child: RadioListTile<String>(
        value: value, groupValue: groupValue, title: Text(title, style: const TextStyle(fontSize: 14)),
        onChanged: onChanged, activeColor: AppColors.c6, contentPadding: EdgeInsets.zero, dense: true,
      ),
    );
  }
}