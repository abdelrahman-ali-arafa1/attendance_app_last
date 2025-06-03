import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'font_manager.dart';

TextStyle getTextStyle(double fontSize,FontWeight fontWeight,Color color,){
  return TextStyle(
    fontSize: fontSize.sp,
    fontWeight: fontWeight,
    color: color,
    fontFamily: FontFamily.fontFamily
  );
}