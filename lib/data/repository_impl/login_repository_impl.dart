import 'dart:developer';
import 'dart:convert';

import 'package:attend_app/core/Errors/dio_error.dart';
import 'package:attend_app/core/Services/shared_preference_services.dart';
import 'package:attend_app/core/Utils/constant_manager.dart';
import 'package:attend_app/core/modals/course_list_model.dart';
import 'package:attend_app/data/data_source/login_remote_data_source.dart';
import 'package:attend_app/domain/entity/login_response_entity.dart';
import 'package:attend_app/domain/repository/login_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: LoginRepository)
class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDataSource _loginRemoteDataSource;

  LoginRepositoryImpl(this._loginRemoteDataSource);
  final coursesList = CourseListModel();
  @override
  Future<Either<DioFailure, LoginResponseEntity>> login(
      String username, String password) async {
    var response = await _loginRemoteDataSource.login(username, password);
    log("Response $response");
    try {
      if (response.statusCode == 200) {
        var data = LoginResponseEntity.fromJson(response.data);
        log(data.toString());
        SharedPreferenceServices.saveData(
            AppConstants.token, data.token.toString());
        log(data.token.toString());
        coursesList.coursesList = data.data!.courses ?? [];
        log(coursesList.coursesList
            .map((e) => {'id': e.id, 'name': e.courseName})
            .toList()
            .toString());

        // حفظ قائمة الكورسات في SharedPreferences كـ JSON
        final coursesJson = jsonEncode(
          coursesList.coursesList
              .map((e) => {'id': e.id, 'courseName': e.courseName})
              .toList(),
        );
        await SharedPreferenceServices.saveData('coursesList', coursesJson);

        // حفظ اسم المستخدم والبريد الإلكتروني
        await SharedPreferenceServices.saveData(
            AppConstants.userName, data.data?.name ?? "");
        await SharedPreferenceServices.saveData(
            AppConstants.userEmail, data.data?.email ?? "");

        await SharedPreferenceServices.saveData(
            AppConstants.studentId, data.data!.id.toString());
        log(data.data!.id.toString());

        // حفظ المعلومات الأكاديمية الإضافية
        if (data.data?.department != null) {
          await SharedPreferenceServices.saveData(
              'department', data.data?.department);
        }
        if (data.data?.level != null) {
          await SharedPreferenceServices.saveData('level', data.data?.level);
        }
        if (data.data?.semester != null) {
          await SharedPreferenceServices.saveData(
              'semester', data.data?.semester);
        }

        return Right(data);
      } else {
        return Left(
            ServerFailure.badFromResponse(response.statusCode!, response.data));
      }
    } catch (e, s) {
      log(s.toString());
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      } else if (e is NetworkFailure) {
        return Left(NetworkFailure(e.errorMessage));
      } else {
        return left(ServerFailure(e.toString()));
      }
    }
  }
}
