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
import 'package:attend_app/ui/login_screen/widget/CustomAuthButton.dart';
import 'package:attend_app/ui/login_screen/widget/CustomTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreenView extends StatelessWidget {
  const LoginScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    LoginViewModel viewModel = getIt.get<LoginViewModel>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ColorsManager.primaryColor,
              ColorsManager.primaryColorDark.withOpacity(0.9),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: BlocConsumer<LoginViewModel, LoginState>(
                bloc: viewModel,
                listener: (context, state) async {
                  if (state is LoadingLoginState) {
                    EasyLoading.show();
                  }
                  if (state is FailureLoginState) {
                    EasyLoading.dismiss();
                    DialogUtils.showMessage(
                      context: context,
                      message: state.errMessage,
                      title: "Error",
                      postActionName: "Cancel",
                    );
                  }
                  if (state is SuccessLoginState) {
                    EasyLoading.dismiss();
                    Navigator.pushReplacementNamed(
                        context, PagesRoutes.layoutScreen);
                  }
                },
                builder: (context, state) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo Animation
                        FadeInDown(
                          duration: const Duration(milliseconds: 900),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.all(18.w),
                            child: Hero(
                              tag: 'app_logo',
                              child: Image.asset(
                                ImageAssets.appLogo,
                                height: 80.w,
                                width: 80.w,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 28.h),
                        // Welcome Text
                        FadeInLeft(
                          duration: const Duration(milliseconds: 800),
                          child: Text(
                            "Welcome To FCAI",
                            style: getTextStyle(
                              FontSize.s22,
                              FontWeightManager.bold,
                              Colors.white,
                            ),
                          ),
                        ),
                        FadeInRight(
                          duration: const Duration(milliseconds: 800),
                          child: Text(
                            "Attendance System 👋",
                            style: getTextStyle(
                              FontSize.s20,
                              FontWeightManager.medium,
                              Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 32.h),
                        // Login Form
                        FadeInUp(
                          duration: const Duration(milliseconds: 900),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                horizontal: 18.w, vertical: 24.h),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? ColorsManager.darkCardColor
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.07),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Form(
                              key: viewModel.formLoginKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Login",
                                    style: getTextStyle(
                                      FontSize.s18,
                                      FontWeightManager.semiBold,
                                      isDark
                                          ? ColorsManager.whiteColor
                                          : ColorsManager.primaryColor,
                                    ),
                                  ),
                                  SizedBox(height: 6.h),
                                  Text(
                                    "Please sign in to continue",
                                    style: getTextStyle(
                                      FontSize.s14,
                                      FontWeightManager.regular,
                                      isDark
                                          ? ColorsManager.darkTextSecondary
                                          : ColorsManager.lightTextSecondary,
                                    ),
                                  ),
                                  SizedBox(height: 18.h),
                                  CustomTextFormField(
                                    validate: AppValidate.validateEmail,
                                    controller: viewModel.emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    text: "Email",
                                    prefixIcon:
                                        const Icon(Icons.email_outlined),
                                  ),
                                  SizedBox(height: 14.h),
                                  CustomTextFormField(
                                    keyboardType: TextInputType.visiblePassword,
                                    validate: AppValidate.validatePassword,
                                    controller: viewModel.passwordController,
                                    text: "Password",
                                    obscureText: viewModel.isPasswordHidden,
                                    prefixIcon: const Icon(Icons.lock_outline),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        viewModel.togglePasswordVisibility();
                                      },
                                      icon: Icon(
                                        viewModel.isPasswordHidden
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        "Forgot Password?",
                                        style: getTextStyle(
                                          FontSize.s14,
                                          FontWeightManager.medium,
                                          ColorsManager.primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 18.h),
                                  CustomButton(
                                    onPressed: () {
                                      if (viewModel.formLoginKey.currentState!
                                          .validate()) {
                                        viewModel.login();
                                      }
                                    },
                                    child: Text(
                                      "Login",
                                      style: getTextStyle(
                                        FontSize.s16,
                                        FontWeightManager.medium,
                                        ColorsManager.whiteColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 30.h),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
