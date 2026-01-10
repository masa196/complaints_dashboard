import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../controller/bloc/admin_complaints/admin_complaints_bloc.dart';


class AdminComplaintsPage extends StatelessWidget {
  const AdminComplaintsPage({Key? key}) : super(key: key);

  static const List<Map<String, String>> _filters = [
    {'label': 'الكل', 'key': 'all'},
    {'label': 'جديدة', 'key': 'new'},
    {'label': 'قيد المعالجة', 'key': 'in_progress'},
    {'label': 'تم الحل', 'key': 'resolved'},
    {'label': 'مرفوضة', 'key': 'rejected'},
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _filters.length,
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          _buildTabBar(context),
          const SizedBox(height: 20),
          Expanded(child: _buildComplaintsList()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Icon(Icons.assignment_rounded, color: AppColors.c6, size: 30),
        const SizedBox(width: 12),
        const Text(
          "إدارة ومعالجة الشكاوي",
          style: TextStyle(
            color: AppColors.c1,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.c3.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        isScrollable: true,
        indicatorColor: AppColors.c6,
        labelColor: AppColors.c6,
        unselectedLabelColor: AppColors.grey,
        indicatorSize: TabBarIndicatorSize.tab,
        onTap: (index) {
          final key = _filters[index]['key'];
          context.read<AdminComplaintsBloc>().add(
            FetchAdminComplaintsEvent(status: key == 'all' ? null : key),
          );
        },
        tabs: _filters.map((f) => Tab(text: f['label'])).toList(),
      ),
    );
  }

  Widget _buildComplaintsList() {
    return BlocBuilder<AdminComplaintsBloc, AdminComplaintsState>(
      builder: (context, state) {
        if (state is AdminComplaintsLoading) {
          return const Center(child: CircularProgressIndicator(color: AppColors.c6));
        } else if (state is AdminComplaintsError) {
          return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
        } else if (state is AdminComplaintsLoaded) {
          if (state.complaints.isEmpty) {
            return Center(
              child: Text("لا توجد شكاوي", style: TextStyle(color: AppColors.c1.withOpacity(0.6))),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 20),
            itemCount: state.complaints.length,
            itemBuilder: (context, index) => _ComplaintItemCard(complaint: state.complaints[index]),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _ComplaintItemCard extends StatelessWidget {
  final dynamic complaint;
  const _ComplaintItemCard({required this.complaint});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.c3.withOpacity(0.4),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.c5.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.tag, color: AppColors.c6, size: 18),
                  Text(
                    " ${complaint.referenceNumber ?? '---'}",
                    style: const TextStyle(color: AppColors.c6, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              _buildStatusBadge(complaint.status ?? ""),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: AppColors.c5, thickness: 0.3),
          ),

          // Title
          Text(
            complaint.title ?? "بدون عنوان",
            style: const TextStyle(color: AppColors.c1, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),

          // Detailed Info Grid-like view
          _buildInfoRow(Icons.person_outline, "مقدم الشكوى:", complaint.user?.name ?? "غير متوفر"),
          _buildInfoRow(Icons.business_outlined, "الجهة المعنية:", complaint.agency?.name ?? "غير معروفة"),
          _buildInfoRow(Icons.location_on_outlined, "الموقع:", complaint.location ?? "غير محدد"),
          _buildInfoRow(Icons.calendar_today_outlined, "تاريخ التقديم:",
              DateFormat('yyyy-MM-dd – hh:mm a').format(complaint.createdAt ?? DateTime.now())),

          const SizedBox(height: 12),

          // Description Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.c4.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("التفاصيل:", style: TextStyle(color: AppColors.c2, fontSize: 13, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text(
                  complaint.description ?? "لا يوجد وصف",
                  style: TextStyle(color: AppColors.c1.withOpacity(0.8), fontSize: 14, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.c2, size: 18),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(color: AppColors.grey, fontSize: 14)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: AppColors.c1, fontSize: 14, fontWeight: FontWeight.w500),
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String text;
    switch (status) {
      case 'new': color = Colors.green; text = "جديدة"; break;
      case 'in_progress': color = AppColors.c2; text = "قيد المعالجة"; break;
      case 'resolved': color = AppColors.c5; text = "تم الحل"; break;
      case 'rejected': color = Colors.redAccent; text = "مرفوضة"; break;
      default: color = AppColors.grey; text = status;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(text, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }
}