import 'package:attend_app/core/Errors/dio_error.dart';
import 'package:attend_app/domain/entity/login_response_entity.dart';
import 'package:attend_app/domain/repository/login_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
@injectable
class LoginUseCase {
  LoginUseCase(this._loginRepository);

  final LoginRepository _loginRepository;

  Future<Either<DioFailure, LoginResponseEntity>> call(
      String username, String password) async {
    return await _loginRepository.login(username, password);
  }
}
