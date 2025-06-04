import 'dart:developer';
import 'dart:math' as math;

import 'package:animate_do/animate_do.dart';
import 'package:attend_app/core/Utils/colors_manager.dart';
import 'package:attend_app/ui/layout/manager/attendance_cubit/attendance_state.dart';
import 'package:attend_app/ui/layout/manager/attendance_cubit/attendance_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/Widget/custom_diaolg.dart';
import '../../../core/modals/course_list_model.dart';

class AttendanceTabScreen extends StatefulWidget {
  const AttendanceTabScreen({super.key});

  @override
  State<AttendanceTabScreen> createState() => _AttendanceTabScreenState();
}

class _AttendanceTabScreenState extends State<AttendanceTabScreen> {
  String? _selectedCourseId;
  bool _showFullList = false;

  @override
  void initState() {
    super.initState();
    final courses = CourseListModel().coursesList;
    if (courses.isNotEmpty) {
      _selectedCourseId = courses[0].id;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String trend,
    required Color color,
    required IconData icon,
    required bool isPositive,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withAlpha(51),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              Icon(icon, color: color, size: 20),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Row(
                children: [
                  Icon(
                    isPositive ? Icons.trending_up : Icons.trending_down,
                    color: color,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    trend,
                    style: TextStyle(
                      color: color,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 1,
        decoration: BoxDecoration(
          color:
              isDark ? Colors.white.withAlpha(26) : Colors.grey.withAlpha(51),
          borderRadius: BorderRadius.circular(1),
        ),
      ),
    );
  }

  Widget _buildAttendanceCharts(
      BuildContext context, bool isDark, dynamic report) {
    // Move calculations here to avoid duplication
    final totalStudents = _calculateTotalStudents(report);
    final presentPercentage =
        _calculatePercentage(report?.present ?? 0, totalStudents);
    final absentPercentage =
        _calculatePercentage(report?.absent ?? 0, totalStudents);

    return Column(
      children: [
        // Bar Chart
        Container(
          height: 300,
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 44),
          decoration: _getCommonDecoration(isDark),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Present vs Absent',
                style: _getTextStyle(isDark, size: 18, isBold: true),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: math.max<double>((report?.present ?? 0).toDouble(),
                            (report?.absent ?? 0).toDouble()) *
                        1.2,
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 150,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toInt().toString(),
                              style: TextStyle(
                                color: isDark
                                    ? Colors.white70
                                    : Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 36,
                          getTitlesWidget: (value, meta) {
                            const titles = ['Present', 'Absent'];
                            if (value.toInt() < titles.length) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  titles[value.toInt()],
                                  style: TextStyle(
                                    color: isDark
                                        ? Colors.white70
                                        : Colors.grey.shade600,
                                    fontSize: 14,
                                  ),
                                ),
                              );
                            }
                            return const Text('');
                          },
                        ),
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 150,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: isDark ? Colors.white12 : Colors.grey.shade200,
                          strokeWidth: 1,
                        );
                      },
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: [
                      BarChartGroupData(
                        x: 0,
                        barRods: [
                          BarChartRodData(
                            toY: (report?.present ?? 0).toDouble(),
                            color: const Color(0xFF4CAF50),
                            width: 40,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(6),
                              topRight: Radius.circular(6),
                            ),
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 1,
                        barRods: [
                          BarChartRodData(
                            toY: (report?.absent ?? 0).toDouble(),
                            color: const Color(0xFFFF5252),
                            width: 40,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(6),
                              topRight: Radius.circular(6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Donut Chart
        Container(
          height: 250,
          padding: const EdgeInsets.all(20),
          decoration: _getCommonDecoration(isDark),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 0,
                          centerSpaceRadius: 60,
                          sections: [
                            PieChartSectionData(
                              color: const Color(0xFF4CAF50),
                              value: presentPercentage,
                              title: '',
                              radius: 20,
                              showTitle: false,
                            ),
                            PieChartSectionData(
                              color: const Color(0xFFFF5252),
                              value: absentPercentage,
                              title: '',
                              radius: 20,
                              showTitle: false,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF4CAF50),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Present',
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${report?.present ?? 0} actions',
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black87,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '(${presentPercentage.toStringAsFixed(1)}%)',
                            style: TextStyle(
                              color: isDark
                                  ? Colors.white70
                                  : Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFF5252),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Absent',
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${report?.absent ?? 0} actions',
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black87,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '(${absentPercentage.toStringAsFixed(1)}%)',
                            style: TextStyle(
                              color: isDark
                                  ? Colors.white70
                                  : Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Helper methods to avoid duplicate calculations
  int _calculateTotalStudents(dynamic report) {
    return (report?.present ?? 0) + (report?.absent ?? 0);
  }

  double _calculatePercentage(int value, int total) {
    return total > 0 ? (value / total * 100) : 0.0;
  }

  // Helper methods for commonly used text styles
  TextStyle _getTextStyle(bool isDark,
      {bool isBold = false, double size = 14.0, bool isSecondary = false}) {
    Color textColor;
    if (isSecondary) {
      textColor = isDark ? Colors.white70 : Colors.grey.shade600;
    } else {
      textColor = isDark ? Colors.white : Colors.black87;
    }

    return TextStyle(
      fontSize: size,
      fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
      color: textColor,
    );
  }

  // Helper method for common decoration
  BoxDecoration _getCommonDecoration(bool isDark,
      {Color? borderColor, double borderRadius = 16}) {
    return BoxDecoration(
      color: isDark ? Colors.black12 : Colors.white,
      borderRadius: BorderRadius.circular(borderRadius),
      border: borderColor != null ? Border.all(color: borderColor) : null,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(13),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  // Helper method for retry button used in both error and no data states
  Widget _buildRetryButton(AttendanceViewModel viewModel) {
    return ElevatedButton.icon(
      onPressed: () {
        final courses = CourseListModel().coursesList;
        if (courses.isNotEmpty) {
          viewModel.fetchAttendanceData(courses[0].id.toString());
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorsManager.primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      icon: const Icon(Icons.refresh),
      label: const Text("إعادة المحاولة"),
    );
  }

  // Fix the error and no data states to use the new method
  Widget _buildErrorState(AttendanceViewModel viewModel, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: ColorsManager.redColor,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          _buildRetryButton(viewModel),
        ],
      ),
    );
  }

  // Helper method for the loading state
  Widget _buildLoadingState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: ColorsManager.primaryColor,
          ),
          const SizedBox(height: 16),
          Text(
            "Loading attendance data...",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? ColorsManager.darkTextPrimary
                  : ColorsManager.lightTextPrimary,
            ),
          ),
        ],
      ),
    );
  }

  // Helper method for course dropdown
  Widget _buildCourseDropdown(bool isDark, List<dynamic> courses) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? Colors.black12 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.white24 : Colors.grey.shade300,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: _selectedCourseId,
          items: courses.map((course) {
            return DropdownMenuItem<String>(
              value: course.id,
              child: Text(
                course.courseName ?? 'Unknown Course',
                style: _getTextStyle(isDark, size: 16),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedCourseId = newValue;
              });
              context.read<AttendanceViewModel>().fetchAttendanceData(newValue);
            }
          },
        ),
      ),
    );
  }

  // Helper method for the calendar button
  Widget _buildCalendarButton(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.black12 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.white24 : Colors.grey.shade300,
        ),
      ),
      child: Icon(
        Icons.calendar_today,
        color: isDark ? Colors.white : Colors.black87,
      ),
    );
  }

  // Helper method for attendance list item
  Widget _buildAttendanceListItem(dynamic attendance, bool isDark) {
    final student = attendance?.student;
    final isPresent = attendance?.attendanceStatus == 'present';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? Colors.white.withAlpha(143)
                : Colors.black.withAlpha(143),
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isPresent
                  ? Colors.green.withAlpha(143)
                  : Colors.red.withAlpha(143),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isPresent ? Icons.check_circle : Icons.cancel,
              color: isPresent ? Colors.green : Colors.red,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student?.name ?? 'Unknown Student',
                  style: _getTextStyle(isDark, size: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  'ID: ${student?.id ?? 'N/A'}',
                  style: _getTextStyle(isDark, isSecondary: true, size: 14),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: isPresent
                  ? Colors.green.withAlpha(143)
                  : Colors.red.withAlpha(143),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isPresent ? 'Present' : 'Absent',
              style: TextStyle(
                color: isPresent ? Colors.green : Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build the entire attendance list section
  Widget _buildAttendanceListSection(dynamic report, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.black12 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.white24 : Colors.grey.shade300,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Attendance List',
                  style: _getTextStyle(isDark, size: 18, isBold: true),
                ),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _showFullList = !_showFullList;
                    });
                  },
                  icon: Icon(
                    _showFullList ? Icons.visibility_off : Icons.visibility,
                  ),
                  label: Text(
                    _showFullList ? 'Show Less' : 'Show All',
                  ),
                ),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _showFullList
                ? report?.attendances?.length
                : report?.attendances?.length.clamp(0, 5),
            itemBuilder: (context, index) {
              final attendance = report?.attendances?[index];
              return _buildAttendanceListItem(attendance, isDark);
            },
          ),
        ],
      ),
    );
  }

  // Helper method for no matching records found
  Widget _buildNoRecordsFound(bool isDark) {
    return Center(
      child: Text(
        'No matching records found',
        style: TextStyle(
          color: isDark ? Colors.white70 : Colors.black54,
          fontSize: 16,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<AttendanceViewModel>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<AttendanceViewModel, AttendanceState>(
      listener: (context, state) {
        if (state is ErrorAttendanceState) {
          DialogUtils.showMessage(
            context: context,
            message: state.errMessage,
            title: "Error",
            postActionName: "Cancel",
          );
        }
        if (state is UpdateAttendanceIndexState) {
          viewModel.report = state.report;
          log("report ${viewModel.report!.present.toString()}");
        }
      },
      builder: (context, state) {
        if (state is LoadingAttendanceState || state is UpdateLoadingState) {
          return _buildLoadingState(isDark);
        }

        if ((state is SuccessAttendanceState ||
                state is UpdateAttendanceIndexState) &&
            (state is SuccessAttendanceState
                    ? state.report
                    : viewModel.report) !=
                null) {
          final report =
              state is SuccessAttendanceState ? state.report : viewModel.report;
          final courses = CourseListModel().coursesList;

          _selectedCourseId ??= courses.isNotEmpty ? courses[0].id : null;

          final totalStudents = (report?.present ?? 0) + (report?.absent ?? 0);
          final attendanceRate = totalStudents > 0
              ? ((report?.present ?? 0) / totalStudents * 100)
                  .toStringAsFixed(1)
              : '0.0';

          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with Course Selection
                      FadeInDown(
                        duration: const Duration(milliseconds: 500),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildCourseDropdown(isDark, courses),
                            ),
                            const SizedBox(width: 12),
                            _buildCalendarButton(isDark),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Statistics Cards
                      FadeInUp(
                        duration: const Duration(milliseconds: 600),
                        child: Column(
                          children: [
                            _buildStatCard(
                              title: 'Attendance Rate',
                              value: '$attendanceRate%',
                              trend: 'Poor',
                              color: Colors.blue,
                              icon: Icons.analytics,
                              isPositive: false,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildStatCard(
                                    title: 'Present',
                                    value: '${report?.present ?? 0}',
                                    trend:
                                        '${((report?.present ?? 0) / totalStudents * 100).toStringAsFixed(1)}%',
                                    color: Colors.green,
                                    icon: Icons.check_circle,
                                    isPositive: true,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildStatCard(
                                    title: 'Absent',
                                    value: '${report?.absent ?? 0}',
                                    trend:
                                        '${((report?.absent ?? 0) / totalStudents * 100).toStringAsFixed(1)}%',
                                    color: Colors.red,
                                    icon: Icons.cancel,
                                    isPositive: false,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Replace the old trend chart with new charts
                      FadeInUp(
                        duration: const Duration(milliseconds: 700),
                        child: _buildAttendanceCharts(context, isDark, report),
                      ),

                      _buildDivider(isDark),

                      // Attendance List
                      if (report?.attendances?.isNotEmpty == true)
                        FadeInUp(
                          duration: const Duration(milliseconds: 1000),
                          child: _buildAttendanceListSection(report, isDark),
                        )
                      else
                        FadeInUp(
                          duration: const Duration(milliseconds: 800),
                          child: _buildNoRecordsFound(isDark),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        // No data state
        if ((state is SuccessAttendanceState ||
                state is UpdateAttendanceIndexState) &&
            (state is SuccessAttendanceState
                    ? state.report
                    : viewModel.report) ==
                null) {
          return _buildErrorState(viewModel, "لا توجد بيانات حضور");
        }

        // Error state
        return _buildErrorState(viewModel, "حدث خطأ أثناء تحميل البيانات");
      },
    );
  }
}
