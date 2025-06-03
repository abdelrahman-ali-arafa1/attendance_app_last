import 'package:attend_app/core/Errors/dio_error.dart';
import 'package:attend_app/domain/entity/QRCodeResponseEntity.dart';
import 'package:attend_app/domain/entity/ReportAttendanceReportEntity.dart';
import 'package:dartz/dartz.dart';

abstract class LayoutRepository {
  Future<Either<DioFailure, QrCodeResponseEntity>> sendQR(String studentId,
      String sessionId, String attendanceStatus);
  Future<Either<DioFailure,ReportAttendanceReportEntity>> getAttendance(String courseId);
}