import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/Utils/colors_manager.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.onPressed, required this.child});

  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            side:
                const BorderSide(color: ColorsManager.primaryColor, width: 1.2),
            fixedSize: Size(MediaQuery.of(context).size.width, 50.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            backgroundColor: ColorsManager.primaryColor,
            elevation: 0),
        onPressed: onPressed,
        child: child);
  }
}
