import '../../domain/entity/login_response_entity.dart';
import 'package:attend_app/core/Services/shared_preference_services.dart';
import 'dart:convert';

class CourseListModel {
  static final CourseListModel _instance = CourseListModel._internal();

  factory CourseListModel() => _instance;

  CourseListModel._internal();
  List<Courses> coursesList = [];

  Future<void> loadCoursesFromPrefs() async {
    if (coursesList.isEmpty) {
      final coursesJson = SharedPreferenceServices.getData('coursesList');
      if (coursesJson != null && coursesJson.toString().isNotEmpty) {
        final List decoded = jsonDecode(coursesJson.toString());
        coursesList = decoded
            .map((e) => Courses(
                  id: e['id'],
                  courseName: e['courseName'],
                ))
            .toList();
      }
    }
  }
}
