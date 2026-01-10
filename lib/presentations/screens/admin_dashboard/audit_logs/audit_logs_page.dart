import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/models/audit_log/audit_log_model.dart';
import '../../../controller/bloc/audit_logs/audit_bloc.dart';

class AuditLogsPage extends StatelessWidget {
  const AuditLogsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuditBloc, AuditState>(
      builder: (context, state) {
        if (state is AuditLoading) return const Center(child: CircularProgressIndicator());
        if (state is AuditError) {
          return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
        }

        if (state is AuditLoaded) {
          final data = state.auditResponse.data;
          return Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 25),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildTableHead(),
                        Expanded(
                          child: ListView.separated(
                            itemCount: data.data.length,
                            separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey.shade100),
                            itemBuilder: (context, index) => _buildAuditRow(data.data[index]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _buildAdvancedPagination(data, context),
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "سجلات العمليات",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white), // تم تغيير اللون للأبيض ليظهر فوق الخلفية الداكنة
        ),
        const SizedBox(height: 6),
        Text(
          "يمكنك هنا رؤية كل عمليات النظام ومراقبة التغييرات بدقة",
          style: TextStyle(fontSize: 15, color: Colors.white.withOpacity(0.7), letterSpacing: 0.5),
        ),
      ],
    );
  }

  Widget _buildTableHead() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Row(
        children: const [
          Expanded(flex: 2, child: Text("العملية", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey))),
          Expanded(flex: 3, child: Text("المستخدم", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey))),
          Expanded(flex: 2, child: Text("التاريخ والوقت", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey))),
        ],
      ),
    );
  }

  Widget _buildAuditRow(AuditLogItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                _buildStatusDot(item.method),
                const SizedBox(width: 10),
                Text(
                  item.action.split('@').last,
                  style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF203B37)),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.actor?.name ?? 'نظام', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF203B37))),
                Text(item.actor?.email ?? '-', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              item.createdAt.substring(0, 16).replaceAll('T', ' '),
              style: TextStyle(color: Colors.blueGrey.shade700, fontSize: 13, fontFamily: 'monospace'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusDot(String method) {
    Color color = method == 'POST' ? Colors.green : (method == 'DELETE' ? Colors.red : Colors.blue);
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _buildAdvancedPagination(AuditPaginationData data, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildPageBtn(
              icon: Icons.first_page,
              isActive: data.currentPage > 1,
              onTap: () => context.read<AuditBloc>().add(const FetchAuditLogsEvent(1))
          ),
          _buildPageBtn(
              icon: Icons.arrow_back_ios_new,
              isActive: data.currentPage > 1,
              onTap: () => context.read<AuditBloc>().add(FetchAuditLogsEvent(data.currentPage - 1))
          ),

          const SizedBox(width: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white24)
            ),
            child: Text(
              "صفحة ${data.currentPage} من ${data.lastPage}",
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          const SizedBox(width: 15),

          _buildPageBtn(
              icon: Icons.arrow_forward_ios,
              isActive: data.currentPage < data.lastPage,
              onTap: () => context.read<AuditBloc>().add(FetchAuditLogsEvent(data.currentPage + 1))
          ),
          _buildPageBtn(
              icon: Icons.last_page,
              isActive: data.currentPage < data.lastPage,
              onTap: () => context.read<AuditBloc>().add(FetchAuditLogsEvent(data.lastPage))
          ),
        ],
      ),
    );
  }

  Widget _buildPageBtn({required IconData icon, required bool isActive, required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: IconButton(
        onPressed: isActive ? onTap : null,
        icon: Icon(icon, size: 28),
        color: Colors.white,
        disabledColor: Colors.white24,
        splashRadius: 30,
      ),
    );
  }
}