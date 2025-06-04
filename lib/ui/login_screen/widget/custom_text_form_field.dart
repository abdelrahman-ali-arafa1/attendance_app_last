import 'package:flutter/material.dart';
import '../../../core/Utils/colors_manager.dart';
import '../../../core/Utils/font_manager.dart';
import '../../../core/Utils/style_manager.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
      {super.key,
      required this.keyboardType,
      this.obscureText = false,
      this.controller,
      required this.text,
      this.suffixIcon,
      this.prefixIcon,
      this.validate,
      this.initialValue});

  final TextInputType keyboardType;
  final bool obscureText;
  final TextEditingController? controller;
  final String text;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? Function(String?)? validate;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: ColorsManager.blackColor,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validate,
      controller: controller,
      style: getTextStyle(
          FontSize.s14, FontWeightManager.regular, ColorsManager.blackColor),
      decoration: InputDecoration(
          border: getOutlineBorder(width: 1.2),
          focusedBorder: getOutlineBorder(width: 2),
          enabledBorder: getOutlineBorder(),
          errorBorder: getOutlineBorder(color: Colors.red),
          labelText: text,
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          labelStyle: getTextStyle(FontSize.s14, FontWeightManager.medium,
              ColorsManager.primaryColor)),
    );
  }

  OutlineInputBorder getOutlineBorder(
      {double width = 1.3, Color color = ColorsManager.primaryColor}) {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(width: width, color: color));
  }
}
