import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/Utils/colors_manager.dart';
import '../../../core/Utils/font_manager.dart';
import '../../../core/Utils/style_manager.dart';

class CustomCardAttend extends StatelessWidget {
  const CustomCardAttend({super.key, required this.text, required this.value});

  final String text;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      width: 130.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: ColorsManager.yellowColor),
      child: Column(
        children: [
          Text(
            text,
            style: getTextStyle(FontSize.s20, FontWeightManager.regular,
                ColorsManager.greenColor),
            textAlign: TextAlign.center,
          ),
          Text(
            value,
            style: getTextStyle(FontSize.s24, FontWeightManager.medium,
                ColorsManager.greenColor),
          )
        ],
      ),
    );
  }
}
