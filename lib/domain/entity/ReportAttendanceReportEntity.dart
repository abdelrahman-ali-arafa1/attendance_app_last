import 'package:attend_app/domain/entity/QRCodeResponseEntity.dart';

class ReportAttendanceReportEntity {
  ReportAttendanceReportEntity({
      this.resutl, 
      this.attendances, 
      this.absent, 
      this.present,});

  ReportAttendanceReportEntity.fromJson(dynamic json) {
    resutl = json['resutl'];
    if (json['attendances'] != null) {
      attendances = [];
      json['attendances'].forEach((v) {
        attendances?.add(Attendances.fromJson(v));
      });
    }
    absent = json['absent'];
    present = json['present'];
  }
  num? resutl;
  List<Attendances>? attendances;
  num? absent;
  num? present;

}

class Attendances {
  Attendances({
      this.id, 
      this.attendanceStatus, 
      this.student, 
      this.course,});

  Attendances.fromJson(dynamic json) {
    id = json['_id'];
    attendanceStatus = json['attendanceStatus'];
    student = json['student'] != null ? StudentEntity.fromJson(json['student']) : null;
    course = json['courseId'] != null ? CourseEntity.fromJson(json['courseId']) : null;
  }
  String? id;
  String? attendanceStatus;
  StudentEntity? student;
  CourseEntity? course;


}

