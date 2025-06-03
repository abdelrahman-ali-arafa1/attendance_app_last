import 'dart:convert';
import 'dart:developer';
import 'package:attend_app/core/Utils/constant_manager.dart';
import 'package:attend_app/domain/entity/QRCodeResponseEntity.dart';
import 'package:attend_app/domain/use_case/layout_use_case.dart';
import 'package:attend_app/ui/layout/manager/scan_qr_cubit/scan_qr_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/Services/shared_preference_services.dart';
import '../../../../domain/entity/qr_session_data.dart';

@injectable
class AttendanceCubit extends Cubit<AttendanceState> {
  final LayoutUseCase _layoutUseCase;
late QrSessionData _sessionData;
  AttendanceCubit(this._layoutUseCase) : super(AttendanceInitial());
  QrCodeResponseEntity? code;

  void startScanning() {
    emit(ScanningState());
  }

  void onQRScanned(String qrData) {
    emit(QRDetectedState(qrData));
    final jsonData = json.decode(qrData);
    _sessionData = QrSessionData.fromJson(jsonData);
    sendAttendance( _sessionData.sessionId);
  }

  void sendAttendance(String sessionId) async {
    var studentId = SharedPreferenceServices.getData(AppConstants.studentId.toString()).toString();
    log("studentId: $studentId");
    emit(SendingAttendanceState());
 var result=await _layoutUseCase.sendQR(studentId, _sessionData.sessionId, "present");
 log("result: $result");
 result.fold((l) {
   emit(AttendanceErrorState(l.errorMessage));
 }, (r) {
   emit(AttendanceSuccessState("Attendance marked successfully"));
 },);

  }

  void retry() {
    emit(ScanningState());
  }
}
