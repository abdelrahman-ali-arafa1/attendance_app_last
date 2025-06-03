import 'package:attend_app/core/Errors/dio_error.dart';
import 'package:attend_app/domain/entity/login_response_entity.dart';
import 'package:dartz/dartz.dart';

abstract class LoginRepository {
  Future<Either<DioFailure, LoginResponseEntity>> login(
      String username, String password);
}
