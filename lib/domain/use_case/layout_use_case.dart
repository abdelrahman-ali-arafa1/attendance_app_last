import 'package:attend_app/domain/entity/ReportAttendanceReportEntity.dart';
import 'package:attend_app/domain/repository/layout_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../core/Errors/dio_error.dart';
import '../entity/QRCodeResponseEntity.dart';

@injectable
class LayoutUseCase {
  LayoutUseCase(this._layoutRepository);

  final LayoutRepository _layoutRepository;

  Future<Either<DioFailure, QrCodeResponseEntity>> sendQR(
      String studentId, String sessionId, String attendanceStatus) async {
    return await _layoutRepository.sendQR(
        studentId, sessionId, attendanceStatus);
  }

  Future<Either<DioFailure, ReportAttendanceReportEntity>> call(
      String courseId) async {
    return await _layoutRepository.getAttendance(courseId);
  }
}
