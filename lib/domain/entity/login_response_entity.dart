class LoginResponseEntity {
  LoginResponseEntity({
      this.data, 
      this.token,
  this.message,
  this.status});

  LoginResponseEntity.fromJson(dynamic json) {
    data = json['data'] != null ? UserDataEntity.fromJson(json['data']) : null;
    token = json['token'];
    message = json['message'];
    status = json['status'];
  }
  UserDataEntity? data;
  String? token;
  String?message;
  String?status;

}

class UserDataEntity {
  UserDataEntity({
      this.id, 
      this.name, 
      this.email, 
      this.password, 
      this.courses, 
      this.department, 
      this.level, 
      this.semester, 
      this.studentID,});

  UserDataEntity.fromJson(dynamic json) {
    id = json['_id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    if (json['courses'] != null) {
      courses = [];
      json['courses'].forEach((v) {
        courses?.add(Courses.fromJson(v));
      });
    }
    department = json['department'];
    level = json['level'];
    semester = json['semester'];
    studentID = json['studentID'];
  }
  String? id;
  String? name;
  String? email;
  String? password;
  List<Courses>? courses;
  String? department;
  String? level;
  String? semester;
  String? studentID;

}

class Courses {
  Courses({
      this.id, 
      this.courseName,});

  Courses.fromJson(dynamic json) {
    id = json['_id'];
    courseName = json['courseName'];
  }
  String? id;
  String? courseName;

}