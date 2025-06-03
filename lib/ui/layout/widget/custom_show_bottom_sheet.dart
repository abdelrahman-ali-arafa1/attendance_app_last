import 'package:attend_app/core/Utils/colors_manager.dart';
import 'package:attend_app/di/injectable_initializer.dart';
import 'package:attend_app/domain/entity/ReportAttendanceReportEntity.dart';
import 'package:attend_app/ui/layout/manager/attendance_cubit/attendance_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/Utils/font_manager.dart';
import '../../../core/Utils/style_manager.dart';
import '../../../core/modals/course_list_model.dart';

class CustomShowBottomSheet extends StatelessWidget {
  CustomShowBottomSheet({
    super.key,
  });

  final myCourses = CourseListModel().coursesList;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      width: double.infinity,
      height: MediaQuery.of(context).size.height * .35,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: ColorsManager.grayColor),
      child: ListView.separated(
        separatorBuilder: (context, index) {
          return const Divider(
            color: ColorsManager.whiteColor,
            height: 2,
            thickness: 1.5,
          );
        },
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.pop(context);
              WidgetsBinding.instance.addPostFrameCallback((_) {
                getIt<AttendanceViewModel>()
                    .updateIndex(index);
              });
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Text(
                myCourses[index].courseName.toString(),
                style: getTextStyle(FontSize.s18, FontWeightManager.medium,
                    ColorsManager.blackColor),
              ),
            ),
          );
        },
        itemCount: myCourses.length,
      ),
    );
  }
}
