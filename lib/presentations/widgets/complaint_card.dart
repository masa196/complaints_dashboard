import 'package:flutter/material.dart';
import '../../domain/entities/compaints/complaint.dart';
import '../../core/constants/app_colors.dart';

class ComplaintCard extends StatefulWidget {
  final Complaint complaint;
  final Future<void> Function(int id, String currentStatus) onEditStatus;

  const ComplaintCard({
    Key? key,
    required this.complaint,
    required this.onEditStatus,
  }) : super(key: key);

  @override
  State<ComplaintCard> createState() => _ComplaintCardState();
}

class _ComplaintCardState extends State<ComplaintCard> {
  bool _isProcessing = false;

  String _translateStatus(String status) {
    switch (status.toLowerCase()) {
      case 'new': return 'جديدة';
      case 'in_progress': return 'قيد المعالجة';
      case 'resolved': return 'تم الحل';
      case 'rejected': return 'مرفوضة';
      default: return status;
    }
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'new': return AppColors.c6;
      case 'rejected': return Colors.redAccent;
      case 'resolved': return AppColors.c2;
      case 'in_progress': return Colors.orange;
      default: return AppColors.c5;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.c1,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _statusColor(widget.complaint.status).withOpacity(0.2), width: 1.2),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 3))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('مرجع: #${widget.complaint.referenceNumber}',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.c3, fontSize: 16)),
              _buildStatusBadge(_translateStatus(widget.complaint.status), _statusColor(widget.complaint.status)),
            ],
          ),
          const Divider(height: 25, thickness: 0.8),

          _buildInfoRow(Icons.title_rounded, 'العنوان:', widget.complaint.title),
          _buildInfoRow(Icons.location_on_rounded, 'الموقع:', widget.complaint.location),
          _buildInfoRow(Icons.calendar_today_rounded, 'التاريخ:',
              '${widget.complaint.createdAt.year}-${widget.complaint.createdAt.month}-${widget.complaint.createdAt.day}'),

          const SizedBox(height: 12),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.c4.withOpacity(0.04),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              widget.complaint.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppColors.c4, height: 1.4, fontSize: 13),
            ),
          ),

          const SizedBox(height: 15),

          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 38,
                  child: OutlinedButton.icon(
                    onPressed: _isProcessing ? null : () => _showImageGallery(context),
                    icon: const Icon(Icons.image_outlined, size: 16),
                    label: Text('المرفقات (${widget.complaint.images.length})', style: const TextStyle(fontSize: 12)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.c3,
                      side: const BorderSide(color: AppColors.c3),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 38,
                  child: ElevatedButton(
                    onPressed: _isProcessing
                        ? null
                        : () async {
                      setState(() => _isProcessing = true);
                      await widget.onEditStatus(widget.complaint.id, widget.complaint.status);
                      if (mounted) setState(() => _isProcessing = false);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.c4,
                      foregroundColor: AppColors.c1,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: _isProcessing
                        ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.c1),
                    )
                        : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.edit_square, size: 14),
                        SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            'تحديث الحالة',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.c2),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.c3, fontSize: 13)),
          const SizedBox(width: 5),
          Expanded(child: Text(value, style: const TextStyle(color: AppColors.c4, fontSize: 13), overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(text, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11)),
    );
  }

  void _showImageGallery(BuildContext context) {
    if (widget.complaint.images.isEmpty) return;

    final PageController _pageController = PageController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return Dialog(
            backgroundColor: Colors.black,
            insetPadding: const EdgeInsets.all(10),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.8,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: widget.complaint.images.length,
                    onPageChanged: (index) {
                      setDialogState(() {});
                    },
                    itemBuilder: (context, index) => InteractiveViewer(
                      child: Image.network(
                        widget.complaint.images[index].filePath,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(child: CircularProgressIndicator(color: Colors.white));
                        },
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, color: Colors.white, size: 50),
                      ),
                    ),
                  ),

                  if (widget.complaint.images.length > 1)
                    Positioned(
                      left: 10,
                      child: CircleAvatar(
                        backgroundColor: Colors.black54,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 20),
                          onPressed: () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                        ),
                      ),
                    ),
                  if (widget.complaint.images.length > 1)
                    Positioned(
                      right: 10,
                      child: CircleAvatar(
                        backgroundColor: Colors.black54,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 20),
                          onPressed: () {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                        ),
                      ),
                    ),

                  Positioned(
                    bottom: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "${(_pageController.hasClients ? _pageController.page?.round() ?? 0 : 0) + 1} / ${widget.complaint.images.length}",
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),


                  Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white, size: 30),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}