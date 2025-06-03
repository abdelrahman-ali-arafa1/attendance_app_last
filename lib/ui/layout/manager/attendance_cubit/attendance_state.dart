import 'package:attend_app/domain/entity/ReportAttendanceReportEntity.dart';

sealed class AttendanceState {

}
class LoadingAttendanceState extends AttendanceState {

}
class SuccessAttendanceState extends AttendanceState {
  ReportAttendanceReportEntity report;
  SuccessAttendanceState(this.report);
}
class ErrorAttendanceState extends AttendanceState {
  String errMessage;
  ErrorAttendanceState(this.errMessage);
}
class UpdateAttendanceIndexState extends AttendanceState{
  ReportAttendanceReportEntity report;
  UpdateAttendanceIndexState(this.report);
}
class UpdateLoadingState extends AttendanceState{

}