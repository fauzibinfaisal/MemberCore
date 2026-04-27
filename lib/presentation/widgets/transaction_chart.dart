import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/entities/monthly_trend.dart';

class TransactionChart extends StatelessWidget {
  final List<MonthlyTrend> trend;
  final String? startMonth;
  final String? endMonth;
  final List<String> availableMonths;
  final Function(String start, String end) onRangeChanged;

  const TransactionChart({
    super.key,
    required this.trend,
    this.startMonth,
    this.endMonth,
    required this.availableMonths,
    required this.onRangeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 15.r,
            offset: Offset(0, 5.h),
          ),
        ],
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Monthly Activity',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              _buildRangePicker(context),
            ],
          ),
          SizedBox(height: 24.h),
          SizedBox(
            height: 180.h,
            child: trend.isEmpty
                ? Center(child: Text('No data for selected range'))
                : LineChart(
              _mainData(theme),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRangePicker(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => _showMonthPicker(context),
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_month_outlined,
                size: 16.sp,
                color: theme.colorScheme.primary),
            SizedBox(width: 6.w),
            Text(
              '${_shortenMonth(startMonth)} - ${_shortenMonth(endMonth)}',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _shortenMonth(String? fullMonth) {
    if (fullMonth == null) return '?';
    // "Apr 2026" -> "Apr '26"
    final parts = fullMonth.split(' ');
    if (parts.length < 2) return fullMonth;
    return "${parts[0]} '${parts[1].substring(2)}";
  }

  void _showMonthPicker(BuildContext context) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) {
        String tempStart = startMonth ?? availableMonths.first;
        String tempEnd = endMonth ?? availableMonths.last;

        return StatefulBuilder(
          builder: (context, setModalState) {
            final startIndex = availableMonths.indexOf(tempStart);
            final endIndex = availableMonths.indexOf(tempEnd);
            final isValid = startIndex <= endIndex;

            return Container(
              padding: EdgeInsets.all(24.r),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Range',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('From', style: theme.textTheme.labelMedium),
                            DropdownButton<String>(
                              value: tempStart,
                              isExpanded: true,
                              items: availableMonths.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                              onChanged: (val) {
                                if (val != null) setModalState(() => tempStart = val);
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 20.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('To', style: theme.textTheme.labelMedium),
                            DropdownButton<String>(
                              value: tempEnd,
                              isExpanded: true,
                              items: availableMonths.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                              onChanged: (val) {
                                if (val != null) setModalState(() => tempEnd = val);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (!isValid) ...[
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        Icon(Icons.error_outline_rounded, color: theme.colorScheme.error, size: 16.sp),
                        SizedBox(width: 8.w),
                        Text(
                          'End month must be after start month',
                          style: TextStyle(color: theme.colorScheme.error, fontSize: 12.sp, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                  SizedBox(height: 32.h),
                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      onPressed: isValid
                          ? () {
                        onRangeChanged(tempStart, tempEnd);
                        Navigator.pop(context);
                      }
                          : null,
                      child: Text('Apply Range'),
                    ),
                  ),
                  SizedBox(height: 32.h),
                ],
              ),
            );
          },
        );
      },
    );
  }

  LineChartData _mainData(ThemeData theme) {
    final color = theme.colorScheme.primary;

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index < 0 || index >= trend.length) return const SizedBox();

              // Only show some labels if there are many points
              if (trend.length > 5 && index % (trend.length ~/ 3) != 0) return const SizedBox();

              return Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: Text(
                  trend[index].month.split(' ')[0],
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            reservedSize: 30,
            getTitlesWidget: (value, meta) {
              return Text(
                value.toInt().toString(),
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  fontSize: 10.sp,
                ),
              );
            },
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: trend.length > 1 ? (trend.length - 1).toDouble() : 1,
      minY: 0,
      maxY: trend.isEmpty ? 5 : trend.map((e) => e.count).reduce((a, b) => a > b ? a : b).toDouble() + 1,
      lineBarsData: [
        LineChartBarData(
          spots: trend.asMap().entries.map((e) {
            return FlSpot(e.key.toDouble(), e.value.count.toDouble());
          }).toList(),
          isCurved: true,
          gradient: LinearGradient(
            colors: [color.withValues(alpha: 0.7), color],
          ),
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 4,
                color: color,
                strokeWidth: 2,
                strokeColor: Colors.white,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                color.withValues(alpha: 0.2),
                color.withValues(alpha: 0),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
