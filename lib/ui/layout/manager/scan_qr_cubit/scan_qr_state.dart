abstract class AttendanceState {}

class AttendanceInitial extends AttendanceState {}

class ScanningState extends AttendanceState {}

class QRDetectedState extends AttendanceState {
  final String qrData;
  QRDetectedState(this.qrData);
}

class SendingAttendanceState extends AttendanceState {}

class AttendanceSuccessState extends AttendanceState {
  final String message;
  AttendanceSuccessState(this.message);
}

class AttendanceErrorState extends AttendanceState {
  final String errorMessage;
  AttendanceErrorState(this.errorMessage);
}
