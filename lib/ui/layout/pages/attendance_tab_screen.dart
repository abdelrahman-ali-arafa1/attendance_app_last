import 'dart:developer';
import 'dart:math' as math;

import 'package:animate_do/animate_do.dart';
import 'package:attend_app/core/Utils/assets_manager.dart';
import 'package:attend_app/core/Utils/colors_manager.dart';
import 'package:attend_app/core/Utils/font_manager.dart';
import 'package:attend_app/core/Utils/style_manager.dart';
import 'package:attend_app/ui/layout/manager/attendance_cubit/attendance_state.dart';
import 'package:attend_app/ui/layout/manager/attendance_cubit/attendance_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.2),
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
          SizedBox(height: 12),
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
                  SizedBox(width: 4),
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
      margin: EdgeInsets.symmetric(vertical: 24),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 1,
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withOpacity(0.1)
              : Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(1),
        ),
      ),
    );
  }

  Widget _buildAttendanceCharts(
      BuildContext context, bool isDark, dynamic report) {
    final totalStudents = (report?.present ?? 0) + (report?.absent ?? 0);
    final presentPercentage =
        totalStudents > 0 ? (report?.present ?? 0) / totalStudents * 100 : 0.0;
    final absentPercentage =
        totalStudents > 0 ? (report?.absent ?? 0) / totalStudents * 100 : 0.0;

    return Column(
      children: [
        // Bar Chart
        Container(
          height: 300,
          padding: EdgeInsets.fromLTRB(20, 20, 20, 44),
          decoration: BoxDecoration(
            color: isDark ? Colors.black12 : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Present vs Absent',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: math.max<double>((report?.present ?? 0).toDouble(),
                            (report?.absent ?? 0).toDouble()) *
                        1.2,
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
                            color: Color(0xFF4CAF50),
                            width: 40,
                            borderRadius: BorderRadius.only(
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
                            color: Color(0xFFFF5252),
                            width: 40,
                            borderRadius: BorderRadius.only(
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

        SizedBox(height: 20),

        // Donut Chart
        Container(
          height: 250,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? Colors.black12 : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
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
                              color: Color(0xFF4CAF50),
                              value: presentPercentage,
                              title: '',
                              radius: 20,
                              showTitle: false,
                            ),
                            PieChartSectionData(
                              color: Color(0xFFFF5252),
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
                                decoration: BoxDecoration(
                                  color: Color(0xFF4CAF50),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 8),
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
                          SizedBox(height: 4),
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
                          SizedBox(height: 16),
                          Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: Color(0xFFFF5252),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 8),
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
                          SizedBox(height: 4),
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

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<AttendanceViewModel>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Size screenSize = MediaQuery.of(context).size;

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
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: ColorsManager.primaryColor,
                ),
                SizedBox(height: 16),
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
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with Course Selection
                      FadeInDown(
                        duration: Duration(milliseconds: 500),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  color: isDark ? Colors.black12 : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isDark
                                        ? Colors.white24
                                        : Colors.grey.shade300,
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
                                          style: TextStyle(
                                            color: isDark
                                                ? Colors.white
                                                : Colors.black87,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      if (newValue != null) {
                                        setState(() {
                                          _selectedCourseId = newValue;
                                        });
                                        viewModel.fetchAttendanceData(newValue);
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isDark ? Colors.black12 : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isDark
                                      ? Colors.white24
                                      : Colors.grey.shade300,
                                ),
                              ),
                              child: Icon(
                                Icons.calendar_today,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 24),

                      // Statistics Cards
                      FadeInUp(
                        duration: Duration(milliseconds: 600),
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
                            SizedBox(height: 16),
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
                                SizedBox(width: 16),
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

                      SizedBox(height: 24),

                      // Replace the old trend chart with new charts
                      FadeInUp(
                        duration: Duration(milliseconds: 700),
                        child: _buildAttendanceCharts(context, isDark, report),
                      ),

                      _buildDivider(isDark),

                      // Attendance List
                      if (report?.attendances?.isNotEmpty == true)
                        FadeInUp(
                          duration: Duration(milliseconds: 1000),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isDark ? Colors.black12 : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isDark
                                    ? Colors.white24
                                    : Colors.grey.shade300,
                              ),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Attendance List',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: isDark
                                              ? Colors.white
                                              : Colors.black87,
                                        ),
                                      ),
                                      TextButton.icon(
                                        onPressed: () {
                                          setState(() {
                                            _showFullList = !_showFullList;
                                          });
                                        },
                                        icon: Icon(
                                          _showFullList
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                        ),
                                        label: Text(
                                          _showFullList
                                              ? 'Show Less'
                                              : 'Show All',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: _showFullList
                                      ? report?.attendances?.length
                                      : report?.attendances?.length.clamp(0, 5),
                                  itemBuilder: (context, index) {
                                    final attendance =
                                        report?.attendances?[index];
                                    final student = attendance?.student;
                                    final isPresent =
                                        attendance?.attendanceStatus ==
                                            'present';

                                    return Container(
                                      padding: EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: isDark
                                                ? Colors.white12
                                                : Colors.grey.shade200,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: isPresent
                                                  ? Colors.green
                                                      .withOpacity(0.1)
                                                  : Colors.red.withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Icon(
                                              isPresent
                                                  ? Icons.check_circle
                                                  : Icons.cancel,
                                              color: isPresent
                                                  ? Colors.green
                                                  : Colors.red,
                                              size: 24,
                                            ),
                                          ),
                                          SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  student?.name ??
                                                      'Unknown Student',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: isDark
                                                        ? Colors.white
                                                        : Colors.black87,
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  'ID: ${student?.id ?? 'N/A'}',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: isDark
                                                        ? Colors.white60
                                                        : Colors.black54,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: isPresent
                                                  ? Colors.green
                                                      .withOpacity(0.1)
                                                  : Colors.red.withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              isPresent ? 'Present' : 'Absent',
                                              style: TextStyle(
                                                color: isPresent
                                                    ? Colors.green
                                                    : Colors.red,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        FadeInUp(
                          duration: Duration(milliseconds: 800),
                          child: Center(
                            child: Text(
                              'No matching records found',
                              style: TextStyle(
                                color: isDark ? Colors.white70 : Colors.black54,
                                fontSize: 16,
                              ),
                            ),
                          ),
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
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.info_outline,
                  color: ColorsManager.primaryColor,
                  size: 48,
                ),
                SizedBox(height: 16),
                Text(
                  "لا توجد بيانات حضور",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    final courses = CourseListModel().coursesList;
                    if (courses.isNotEmpty) {
                      viewModel.fetchAttendanceData(courses[0].id.toString());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsManager.primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  icon: const Icon(Icons.refresh),
                  label: const Text("إعادة المحاولة"),
                ),
              ],
            ),
          );
        }

        // Error state
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: ColorsManager.redColor,
                size: 48,
              ),
              SizedBox(height: 16),
              Text(
                "حدث خطأ أثناء تحميل البيانات",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  final courses = CourseListModel().coursesList;
                  if (courses.isNotEmpty) {
                    viewModel.fetchAttendanceData(courses[0].id.toString());
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsManager.primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                icon: const Icon(Icons.refresh),
                label: const Text("إعادة المحاولة"),
              ),
            ],
          ),
        );
      },
    );
  }
}
