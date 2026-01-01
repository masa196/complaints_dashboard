// lib/employee_dashboard/presentation/widgets/complaint_card.dart
import 'package:flutter/material.dart';
import '../../domain/entities/compaints/complaint.dart';
import '../../core/constants/app_colors.dart';

class ComplaintCard extends StatelessWidget {
  final Complaint complaint;
  final void Function(int id, String currentStatus) onEditStatus;

  const ComplaintCard({
    Key? key,
    required this.complaint,
    required this.onEditStatus,
  }) : super(key: key);

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'جديدة':
      case 'new':
        return AppColors.c6;
      case 'مرفوضة':
      case 'rejected':
        return Colors.redAccent;
      case 'منجزة':
      case 'resolved':
        return AppColors.c2;
      case 'قيد التحضير':
      case 'in_progress':
        return AppColors.c5;
      default:
        return AppColors.c4;
    }
  }

  String _displayStatus(String status) {
    return status; // keep raw (server-provided) — if you want mapping to Arabic, do it here
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth < 700 ? screenWidth * 0.85 : 1000.0;

    return Center(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          width: cardWidth,
          margin: const EdgeInsets.symmetric(vertical: 12),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.c1,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.c3.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
            border: Border.all(color: _statusColor(complaint.status).withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // title
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: 'العنوان: ', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.c3)),
                    TextSpan(text: complaint.title, style: const TextStyle(color: AppColors.c4)),
                  ],
                ),
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),

              // description
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: 'الوصف: ', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.c3)),
                    TextSpan(text: complaint.description, style: const TextStyle(color: AppColors.c4)),
                  ],
                ),
                style: const TextStyle(fontSize: 14, height: 1.4),
              ),
              const SizedBox(height: 8),

              // location
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: 'الموقع: ', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.c3)),
                    TextSpan(text: complaint.location, style: const TextStyle(color: AppColors.c4)),
                  ],
                ),
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 12),

              // date & status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 14, color: AppColors.c5),
                      const SizedBox(width: 4),
                      Text(
                        '${complaint.createdAt.day}/${complaint.createdAt.month}/${complaint.createdAt.year}',
                        style: const TextStyle(
                          color: AppColors.c5,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _statusColor(complaint.status).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _displayStatus(complaint.status),
                      style: TextStyle(
                        color: _statusColor(complaint.status),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // edit / request-info button - now passes id + current status
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: () => onEditStatus(complaint.id, complaint.status),
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('تعديل الحالة أو طلب معلومات من المواطن'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.c2,
                    foregroundColor: AppColors.c1,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
