import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../data/models/statistics/statistics_model.dart';
import '../../../controller/bloc/reports/reports_bloc.dart';
import '../../../controller/bloc/statistics/statistics_bloc.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocBuilder<StatisticsBloc, StatisticsState>(
        builder: (context, state) {
          if (state is StatisticsLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.c5));
          } else if (state is StatisticsError) {
            return Center(
              child: Text(state.message, style: const TextStyle(color: Colors.red)),
            );
          } else if (state is StatisticsLoaded) {
            final data = state.statistics.data;
            if (data == null) return const Center(child: Text("لا توجد بيانات"));

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 24),
                  _buildSummaryCards(data),
                  const SizedBox(height: 30),
                  _buildChartsSection(data),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  // داخل StatisticsPage -> _buildHeader
  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(/* نصوص العناوين */),
        BlocConsumer<ReportsBloc, ReportsState>(
          listener: (context, state) {
            if (state is ReportsError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            bool isLoading = state is ReportsLoading;

            return PopupMenuButton<String>(
              enabled: !isLoading,
              onSelected: (type) => context.read<ReportsBloc>().add(StartDownloadEvent(type)),
              itemBuilder: (context) => [
                _buildPopupItem('pdf', Icons.picture_as_pdf, "تصدير PDF", Colors.redAccent, state),
                _buildPopupItem('csv', Icons.table_view, "تصدير CSV", Colors.green, state),
              ],
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(color: AppColors.c5, borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    isLoading
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.c3))
                        : const Icon(Icons.file_download_outlined, color: AppColors.c3),
                    const SizedBox(width: 8),
                    const Text("تصدير التقارير", style: TextStyle(color: AppColors.c3, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  PopupMenuItem<String> _buildPopupItem(String value, IconData icon, String title, Color color, ReportsState state) {
    bool isThisLoading = (state is ReportsLoading && state.type == value);
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          isThisLoading
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : Icon(icon, color: color),
          const SizedBox(width: 12),
          Text(title),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(Data data) {
    return Row(
      children: [
        _statCard("إجمالي المواطنين الذين قدموا شكاوي ", data.usersCount.toString(), Icons.people_alt, AppColors.c5),
        const SizedBox(width: 20),
        _statCard("إجمالي الشكاوي", data.complaintsCount.toString(), Icons.assignment_late, AppColors.c2),
      ],
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color accentColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.c3,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.c5.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: accentColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: accentColor, size: 30),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: AppColors.grey, fontSize: 17)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(color: AppColors.c1, fontSize: 28, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartsSection(Data data) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: _chartContainer(
            title: "توزيع الشكاوى حسب الجهة الحكومية",
            child: _BarChartWidget(data.complaintsByAgency ?? []),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          flex: 1,
          child: _chartContainer(
            title: "حالات الشكاوى",
            child: _PieChartWidget(data.complaintsByStatus ?? []),
          ),
        ),
      ],
    );
  }

  Widget _chartContainer({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 400,
      decoration: BoxDecoration(
        color: AppColors.c3,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: AppColors.c6, fontWeight: FontWeight.bold)),
          const SizedBox(height: 30),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _BarChartWidget extends StatelessWidget {
  final List<ComplaintsByAgency> agencies;
  const _BarChartWidget(this.agencies);

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: (agencies.isEmpty ? 10 : agencies.map((e) => e.total ?? 0).reduce((a, b) => a > b ? a : b) + 5).toDouble(),
        barGroups: agencies.asMap().entries.map((e) {
          return BarChartGroupData(
            x: e.key,
            barRods: [
              BarChartRodData(
                toY: (e.value.total ?? 0).toDouble(),
                color: AppColors.c5,
                width: 25,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
              )
            ],
          );
        }).toList(),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (val, meta) {
                if (val.toInt() >= agencies.length) return const SizedBox();
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    agencies[val.toInt()].agency?.name ?? '',
                    style: const TextStyle(color: AppColors.grey, fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
          ),
          // تحريك أرقام المحور الصادي لليمين بما يتناسب مع RTL
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) => FlLine(color: AppColors.c5.withOpacity(0.1), strokeWidth: 1),
        ),
        borderData: FlBorderData(show: false),
      ),
    );
  }
}

class _PieChartWidget extends StatelessWidget {
  final List<ComplaintsByStatus> statuses;
  const _PieChartWidget(this.statuses);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              sectionsSpace: 4,
              centerSpaceRadius: 40,
              sections: statuses.map((s) {
                return PieChartSectionData(
                  value: (s.total ?? 0).toDouble(),
                  title: '${s.total}',
                  radius: 50,
                  titleStyle: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  color: _getStatusColor(s.status ?? ''),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: statuses.map((s) => _buildLegendItem(s.status ?? '', _getStatusColor(s.status ?? ''))).toList(),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String title, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(_translateStatus(title), style: const TextStyle(color: AppColors.grey, fontSize: 12)),
      ],
    );
  }

  String _translateStatus(String status) {
    switch (status.toLowerCase()) {
      case 'new': return 'جديدة';
      case 'resolved': return 'تم الحل';
      case 'rejected': return 'مرفوضة';
      case 'in_progress': return 'قيد المعالجة';
      case 'pending': return 'قيد الانتظار';
      default: return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'new': return Colors.green;
      case 'resolved': return AppColors.c5;
      case 'rejected': return Colors.redAccent;
      case 'in_progress': return AppColors.c6;
      default: return AppColors.grey;
    }
  }
}