import 'dart:developer';

import 'package:attend_app/core/Errors/dio_error.dart';
import 'package:attend_app/core/Services/shared_preference_services.dart';
import 'package:attend_app/core/Utils/constant_manager.dart';
import 'package:attend_app/data/data_source/layout_remote_data_source.dart';
import 'package:attend_app/domain/entity/QRCodeResponseEntity.dart';
import 'package:attend_app/domain/entity/ReportAttendanceReportEntity.dart';
import 'package:attend_app/domain/repository/layout_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: LayoutRepository)
class LayoutRepositoryImpl implements LayoutRepository {
  LayoutRepositoryImpl(this._layoutRemoteDataSource);

  final LayoutRemoteDataSource _layoutRemoteDataSource;

  @override
  Future<Either<DioFailure, QrCodeResponseEntity>> sendQR
      (String studentId, String sessionId, String attendanceStatus) async {
    var response = await _layoutRemoteDataSource.sendQR(
        studentId, sessionId, attendanceStatus);
    log(SharedPreferenceServices.getData(AppConstants.token.toString()).toString());
  log("Bearer ${SharedPreferenceServices.getData(AppConstants.token).toString()}");
  log(response.toString());
    try {
      if (response.statusCode == 200) {
        var data = QrCodeResponseEntity.fromJson(response.data);
        log(data.toString());
        return Right(data);
      }
      else {
        return Left(
            ServerFailure.BadfromResponse(response.statusCode!, response.data));
      }
    } catch (e, s) {
      log(s.toString());
      if (e is DioException) {
        log(s.toString());
        return left(ServerFailure.fromDioError(e));
      } else if (e is NetworkFailure) {
        return left(NetworkFailure(e.errorMessage));
      } else {
        return Left(ServerFailure(e.toString()));
      }
    }
  }

  @override
  Future<Either<DioFailure, ReportAttendanceReportEntity>> getAttendance(String courseId) async{
    var response=await _layoutRemoteDataSource.getAttendance(courseId);
    log(response.toString());
    try {
      if (response.statusCode==200){
        var data=ReportAttendanceReportEntity.fromJson(response.data);
        return Right(data);
      }
      else {
        return Left(
            ServerFailure.BadfromResponse(response.statusCode!, response.data));
      }
    } catch (e, s) {
      log(s.toString());
      if (e is DioException) {
        log(s.toString());
        return left(ServerFailure.fromDioError(e));
      } else if (e is NetworkFailure) {
        return left(NetworkFailure(e.errorMessage));
      } else {
        return Left(ServerFailure(e.toString()));
      }
    }
  }
}