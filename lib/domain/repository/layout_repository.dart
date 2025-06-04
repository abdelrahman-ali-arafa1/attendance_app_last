import 'package:attend_app/core/Errors/dio_error.dart';
import 'package:attend_app/domain/entity/qr_code_response_entity.dart';
import 'package:attend_app/domain/entity/report_attendance_report_entity.dart';
import 'package:dartz/dartz.dart';

abstract class LayoutRepository {
  Future<Either<DioFailure, QrCodeResponseEntity>> sendQR(
      String studentId, String sessionId, String attendanceStatus);
  Future<Either<DioFailure, ReportAttendanceReportEntity>> getAttendance(
      String courseId);
}
