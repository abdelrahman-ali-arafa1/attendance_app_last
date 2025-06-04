import 'dart:ui';
import 'package:animate_do/animate_do.dart';
import 'package:attend_app/core/Utils/assets_manager.dart';
import 'package:attend_app/core/Utils/colors_manager.dart';
import 'package:attend_app/core/Utils/font_manager.dart';
import 'package:attend_app/core/Utils/style_manager.dart';
import 'package:attend_app/core/Widget/custom_diaolg.dart';
import 'package:attend_app/core/Widget/custom_validate.dart';
import 'package:attend_app/core/routes_manager/page_routes.dart';
import 'package:attend_app/di/injectable_initializer.dart';
import 'package:attend_app/ui/login_screen/manager/login_state.dart';
import 'package:attend_app/ui/login_screen/manager/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreenView extends StatefulWidget {
  const LoginScreenView({super.key});

  @override
  State<LoginScreenView> createState() => _LoginScreenViewState();
}

class _LoginScreenViewState extends State<LoginScreenView> {
  late final LoginViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = getIt.get<LoginViewModel>();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    ColorsManager.darkBackgroundColor,
                    ColorsManager.darkCardColor,
                  ]
                : [
                    ColorsManager.primaryColor.withOpacity(0.9),
                    ColorsManager.primaryColorDark.withOpacity(0.9),
                  ],
          ),
        ),
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                        ),
                        child: Column(
                          children: [
                            // Logo và header - Không hiển thị nếu bàn phím hiện ra
                            SizedBox(height: keyboardVisible ? 10.h : 60.h),
                            if (!keyboardVisible) ...[
                              Hero(
                                tag: 'app_logo',
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundColor: isDark
                                      ? Colors.white.withOpacity(0.1)
                                      : Colors.white.withOpacity(0.9),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(
                                      ImageAssets.appLogo,
                                      width: 70.w,
                                      height: 70.w,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 24.h),
                              Text(
                                "Welcome Back",
                                style: TextStyle(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                "Sign in to continue",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                              SizedBox(height: 32.h),
                            ],

                            // Login form
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                                vertical: 24.h,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? ColorsManager.darkCardColor
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: BlocConsumer<LoginViewModel, LoginState>(
                                bloc: viewModel,
                                listener: (context, state) {
                                  if (state is LoadingLoginState) {
                                    EasyLoading.show();
                                  } else if (state is FailureLoginState) {
                                    EasyLoading.dismiss();
                                    DialogUtils.showMessage(
                                      context: context,
                                      message: state.errMessage,
                                      title: "Error",
                                      postActionName: "OK",
                                    );
                                  } else if (state is SuccessLoginState) {
                                    EasyLoading.dismiss();
                                    Navigator.pushReplacementNamed(
                                        context, PagesRoutes.layoutScreen);
                                  }
                                },
                                builder: (context, state) {
                                  return Form(
                                    key: viewModel.formLoginKey,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Login",
                                          style: TextStyle(
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.bold,
                                            color: isDark
                                                ? Colors.white
                                                : ColorsManager
                                                    .primaryColorDark,
                                          ),
                                        ),
                                        SizedBox(height: 20.h),

                                        // Email field
                                        _buildInputField(
                                          label: "Email",
                                          hint: "Enter your email",
                                          prefixIcon: Icons.email_outlined,
                                          controller: viewModel.emailController,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          validator: AppValidate.validateEmail,
                                          isDark: isDark,
                                        ),
                                        SizedBox(height: 16.h),

                                        // Password field
                                        _buildInputField(
                                          label: "Password",
                                          hint: "Enter your password",
                                          prefixIcon: Icons.lock_outline,
                                          controller:
                                              viewModel.passwordController,
                                          obscureText:
                                              viewModel.isPasswordHidden,
                                          suffixIcon: IconButton(
                                            onPressed: () => viewModel
                                                .togglePasswordVisibility(),
                                            icon: Icon(
                                              viewModel.isPasswordHidden
                                                  ? Icons.visibility_outlined
                                                  : Icons
                                                      .visibility_off_outlined,
                                              color: isDark
                                                  ? Colors.white60
                                                  : Colors.grey.shade600,
                                              size: 20,
                                            ),
                                          ),
                                          validator:
                                              AppValidate.validatePassword,
                                          isDark: isDark,
                                        ),

                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: TextButton(
                                            onPressed: () {},
                                            style: TextButton.styleFrom(
                                              padding: EdgeInsets.zero,
                                              minimumSize: Size.zero,
                                              tapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                            ),
                                            child: Text(
                                              "Forgot Password?",
                                              style: TextStyle(
                                                color:
                                                    ColorsManager.primaryColor,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 24.h),

                                        // Login button
                                        SizedBox(
                                          width: double.infinity,
                                          height: 50.h,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              FocusScope.of(context).unfocus();
                                              if (viewModel
                                                  .formLoginKey.currentState!
                                                  .validate()) {
                                                viewModel.login();
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  ColorsManager.primaryColor,
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              elevation: 2,
                                            ),
                                            child: Text(
                                              "Login",
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),

                            // Spacer takes remaining space
                            Expanded(child: Container()),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // Custom input field builder with consistent style
  Widget _buildInputField({
    required String label,
    required String hint,
    required IconData prefixIcon,
    required TextEditingController controller,
    required bool isDark,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDark ? Colors.white70 : Colors.grey.shade800,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontSize: 14.sp,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: isDark ? Colors.white38 : Colors.grey.shade400,
              fontSize: 14.sp,
            ),
            prefixIcon: Icon(
              prefixIcon,
              color: isDark ? Colors.white60 : ColorsManager.primaryColor,
              size: 20,
            ),
            suffixIcon: suffixIcon,
            fillColor:
                isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade50,
            filled: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? Colors.white24 : Colors.grey.shade300,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? Colors.white24 : Colors.grey.shade300,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: ColorsManager.primaryColor,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: ColorsManager.redColor,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: ColorsManager.redColor,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
