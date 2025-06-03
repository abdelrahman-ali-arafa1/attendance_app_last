import 'dart:developer';

import 'package:attend_app/domain/use_case/login_use_case.dart';
import 'package:attend_app/ui/login_screen/manager/login_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginViewModel extends Cubit<LoginState> {
  LoginViewModel(this._loginUseCase) : super(LoadingLoginState());
  final LoginUseCase _loginUseCase;
  GlobalKey<FormState> formLoginKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Password visibility control
  bool _isPasswordHidden = true;
  bool get isPasswordHidden => _isPasswordHidden;

  void togglePasswordVisibility() {
    _isPasswordHidden = !_isPasswordHidden;
    emit(state); // Re-emit current state to trigger UI update
  }

  void login() async {
    emit(LoadingLoginState());
    var result =
        await _loginUseCase.call(emailController.text, passwordController.text);
    result.fold(
      (error) {
        emit(FailureLoginState(error.errorMessage));
      },
      (response) {
        log(response.data!.email.toString());
        emit(SuccessLoginState());
      },
    );
  }
}
