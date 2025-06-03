import 'package:attend_app/core/Utils/colors_manager.dart';
import 'package:attend_app/core/Utils/font_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeManager {
  // Light Theme
  static ThemeData getLightTheme() {
    return ThemeData(
      useMaterial3: true,
      primaryColor: ColorsManager.primaryColor,
      scaffoldBackgroundColor: Colors.white,
      brightness: Brightness.light,
      textTheme: GoogleFonts.poppinsTextTheme(Typography.englishLike2018.apply(
        bodyColor: ColorsManager.lightTextPrimary,
        displayColor: ColorsManager.lightTextPrimary,
      )),
      colorScheme: const ColorScheme.light(
        primary: ColorsManager.primaryColor,
        secondary: ColorsManager.secondaryColor,
        surface: ColorsManager.grayColor,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        iconTheme: const IconThemeData(
          color: ColorsManager.blackColor,
        ),
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 18.sp,
          fontWeight: FontWeightManager.semiBold,
          color: ColorsManager.blackColor,
        ),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorsManager.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: ColorsManager.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ColorsManager.primaryColor,
          side: const BorderSide(color: ColorsManager.primaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        fillColor: ColorsManager.grayColor,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: ColorsManager.primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: ColorsManager.redColor),
        ),
        hintStyle: GoogleFonts.poppins(
          fontSize: 14.sp,
          fontWeight: FontWeightManager.regular,
          color: ColorsManager.lightTextSecondary,
        ),
      ),
    );
  }

  // Dark Theme
  static ThemeData getDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      primaryColor: ColorsManager.primaryColor,
      scaffoldBackgroundColor: ColorsManager.darkBackgroundColor,
      brightness: Brightness.dark,
      textTheme: GoogleFonts.poppinsTextTheme(Typography.englishLike2018.apply(
        bodyColor: ColorsManager.darkTextPrimary,
        displayColor: ColorsManager.darkTextPrimary,
      )),
      colorScheme: const ColorScheme.dark(
        primary: ColorsManager.primaryColor,
        secondary: ColorsManager.secondaryColor,
        surface: ColorsManager.darkCardColor,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: ColorsManager.darkBackgroundColor,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: ColorsManager.darkBackgroundColor,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        iconTheme: const IconThemeData(
          color: ColorsManager.whiteColor,
        ),
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 18.sp,
          fontWeight: FontWeightManager.semiBold,
          color: ColorsManager.whiteColor,
        ),
      ),
      cardTheme: CardTheme(
        color: ColorsManager.darkCardColor,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorsManager.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: ColorsManager.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ColorsManager.primaryColor,
          side: const BorderSide(color: ColorsManager.primaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        fillColor: ColorsManager.darkCardColor,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: ColorsManager.primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: ColorsManager.redColor),
        ),
        hintStyle: GoogleFonts.poppins(
          fontSize: 14.sp,
          fontWeight: FontWeightManager.regular,
          color: ColorsManager.darkTextSecondary,
        ),
      ),
    );
  }
}
