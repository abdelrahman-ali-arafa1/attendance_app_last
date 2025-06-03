class QrCodeResponseEntity {
  QrCodeResponseEntity({
      this.message, 
      this.studentAttendance,});

  QrCodeResponseEntity.fromJson(dynamic json) {
    message = json['message'];
    studentAttendance =  StudentAttendanceEntity.fromJson(json['studentAttendance']);
  }
  String? message;
  StudentAttendanceEntity? studentAttendance;
}

class StudentAttendanceEntity {
  StudentAttendanceEntity({
      this.id, 
      this.sessionID, 
      this.attendanceStatus, 
      this.scanDate, 
      this.student, 
      this.courseId, 
      this.createdAt, 
      this.updatedAt,});

  StudentAttendanceEntity.fromJson(dynamic json) {
    id = json['_id'];
    sessionID = json['sessionID'];
    attendanceStatus = json['attendanceStatus'];
    scanDate = json['scanDate'];
    student = StudentEntity.fromJson(json['student']) ;
    courseId =  CourseEntity.fromJson(json['courseId']) ;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
  String? id;
  String? sessionID;
  String? attendanceStatus;
  String? scanDate;
  StudentEntity? student;
  CourseEntity? courseId;
  String? createdAt;
  String? updatedAt;
}

class CourseEntity {
  CourseEntity({
      this.id, 
      this.courseName,});

  CourseEntity.fromJson(dynamic json) {
    id = json['_id'];
    courseName = json['courseName'];
  }
  String? id;
  String? courseName;

}

class StudentEntity {
  StudentEntity({
      this.id, 
      this.name,});

  StudentEntity.fromJson(dynamic json) {
    id = json['_id'];
    name = json['name'];
  }
  String? id;
  String? name;


}