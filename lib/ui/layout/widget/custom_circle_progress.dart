
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/Utils/colors_manager.dart';

class CircleProgress extends StatelessWidget {
  const CircleProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350.h,
      width: 350.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: ColorsManager.greenColor.withOpacity(.36),
      ),
      child:  Column(
        children: [
          SizedBox(height: 10.h),
          Text(
            'Performance',
            style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w800,
                color: ColorsManager.greenColor
            ),
          ),
          SizedBox(height: 10.h),
          const Divider(
              thickness: 2,
              color: ColorsManager.greenColor
          ),
          SizedBox(height: 10.h),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 180.w,
                  height: 180.h,
                  child:const CircularProgressIndicator(
                    value: .70, // 95%
                    strokeWidth: 12,
                    backgroundColor: ColorsManager.redColor,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.blue,
                    ),
                  ),
                ),
                Text(
                  '95%',
                  style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: ColorsManager.whiteColor
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          // Labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Absent
              Column(
                children: [
                  Text(
                    'Absent',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: ColorsManager.blackColor,
                    ),
                  ),
                  Text(
                    '5%',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              // Present
              Column(
                children: [
                  Text(
                    'Present',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: ColorsManager.blackColor,
                    ),
                  ),
                  Text(
                    '95%',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
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
}
