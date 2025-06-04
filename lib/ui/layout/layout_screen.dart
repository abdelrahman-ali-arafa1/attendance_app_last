import 'package:attend_app/core/Utils/assets_manager.dart';
import 'package:attend_app/core/Utils/colors_manager.dart';
import 'package:attend_app/core/Utils/font_manager.dart';
import 'package:attend_app/core/Utils/style_manager.dart';
import 'package:attend_app/ui/layout/manager/layout_cubit/layout_state.dart';
import 'package:attend_app/ui/layout/manager/layout_cubit/layout_view_model.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:developer';

import '../../core/modals/course_list_model.dart';
import '../../di/injectable_initializer.dart';
import '../../core/Services/shared_preference_services.dart';
import '../../core/Utils/constant_manager.dart';
import 'manager/attendance_cubit/attendance_view_model.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  late LayoutViewModel viewModel;
  late AttendanceViewModel attendanceViewModel;
  bool _isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    viewModel = LayoutViewModel();
    attendanceViewModel = getIt<AttendanceViewModel>();

    // تحميل الكورسات من SharedPreferences بشكل متزامن ثم تحميل بيانات الحضور
    Future.microtask(() async {
      await CourseListModel().loadCoursesFromPrefs();
      _loadAttendanceData();
    });
  }

  Future<void> _loadAttendanceData() async {
    try {
      // التحقق من وجود التوكن
      final token = SharedPreferenceServices.getData(AppConstants.token);
      log("Layout screen - Loading attendance data. Token: $token");

      if (token != null &&
          token.toString().isNotEmpty &&
          token.toString() != "null") {
        // تحميل قائمة المواد الدراسية
        final coursesList = CourseListModel().coursesList;

        // إذا كانت هناك مواد دراسية، نقوم بتحميل بيانات الحضور للمادة الأولى
        if (coursesList.isNotEmpty && coursesList[0].id != null) {
          log("Loading attendance data for course ID: ${coursesList[0].id}");
          attendanceViewModel.fetchAttendanceData(coursesList[0].id!);
          setState(() {
            _isDataLoaded = true;
          });
        } else {
          log("No courses available to load attendance data");
        }
      } else {
        log("Invalid token, cannot load attendance data");
      }
    } catch (e) {
      log("Error loading attendance data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => viewModel),
        BlocProvider(create: (context) => attendanceViewModel),
      ],
      child: BlocBuilder<LayoutViewModel, LayoutState>(
        builder: (context, state) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: PageTransition(
              type: PageTransitionType.fade,
              child: viewModel.tabs[viewModel.currentIndex],
            ),
            extendBody: true,
            bottomNavigationBar: Container(
              margin: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
              height: 70.h,
              decoration: BoxDecoration(
                color: isDark ? ColorsManager.darkCardColor : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(26),
                    blurRadius: 20,
                    offset: const Offset(0, 5),
                  ),
                ],
                borderRadius: BorderRadius.circular(30),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavItem(
                      context: context,
                      icon: IconAssets.attendIcon,
                      label: "Attendance",
                      isSelected: viewModel.currentIndex == 0,
                      onTap: () {
                        viewModel.changeTab(0);
                        // تحميل البيانات عند التبديل إلى صفحة الحضور
                        if (!_isDataLoaded) {
                          _loadAttendanceData();
                        }
                      },
                    ),
                    _buildNavItem(
                      context: context,
                      icon: IconAssets.scanIcon,
                      label: "Scan",
                      isSelected: viewModel.currentIndex == 1,
                      onTap: () => viewModel.changeTab(1),
                    ),
                    _buildNavItem(
                      context: context,
                      icon: IconAssets.profileIcon,
                      label: "Profile",
                      isSelected: viewModel.currentIndex == 2,
                      onTap: () => viewModel.changeTab(2),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required String icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 100.w,
        padding: EdgeInsets.symmetric(
          horizontal: 12.w,
          vertical: isSelected ? 12.h : 8.h,
        ),
        decoration: BoxDecoration(
          color: isSelected ? ColorsManager.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ImageIcon(
              AssetImage(icon),
              size: isSelected ? 24 : 22,
              color: isSelected
                  ? Colors.white
                  : isDark
                      ? ColorsManager.darkTextSecondary
                      : ColorsManager.lightTextSecondary,
            ),
            if (isSelected)
              FadeIn(
                duration: const Duration(milliseconds: 300),
                child: Column(
                  children: [
                    SizedBox(height: 4.h),
                    Text(
                      label,
                      style: getTextStyle(
                        FontSize.s12,
                        FontWeightManager.medium,
                        Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Animation for page transitions
class PageTransition extends StatelessWidget {
  final Widget child;
  final PageTransitionType type;
  final Curve curve;
  final Duration duration;

  const PageTransition({
    Key? key,
    required this.child,
    this.type = PageTransitionType.fade,
    this.curve = Curves.easeInOut,
    this.duration = const Duration(milliseconds: 300),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case PageTransitionType.fade:
        return FadeIn(
          duration: duration,
          child: child,
        );
      case PageTransitionType.scale:
        return ZoomIn(
          duration: duration,
          child: child,
        );
      case PageTransitionType.slideUp:
        return SlideInUp(
          duration: duration,
          child: child,
        );
    }
  }
}

enum PageTransitionType {
  fade,
  scale,
  slideUp,
}
