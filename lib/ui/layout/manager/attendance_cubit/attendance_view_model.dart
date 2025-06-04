import 'dart:convert';
import 'dart:developer';

import 'package:attend_app/core/Services/shared_preference_services.dart';
import 'package:attend_app/domain/use_case/layout_use_case.dart';
import 'package:attend_app/ui/layout/manager/attendance_cubit/attendance_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/modals/course_list_model.dart';
import '../../../../domain/entity/report_attendance_report_entity.dart';

@injectable
class AttendanceViewModel extends Cubit<AttendanceState> {
  AttendanceViewModel(this._layoutUseCase) : super(LoadingAttendanceState());
  final LayoutUseCase _layoutUseCase;
  ReportAttendanceReportEntity? report;
  Future<void> fetchAttendanceData(String courseId) async {
    emit(LoadingAttendanceState());
    var result = await _layoutUseCase.call(courseId);
    log("result: $result");
    result.fold(
      (error) {
        emit(ErrorAttendanceState(error.errorMessage));
      },
      (response) {
        report = response;
        log("report ${report!.present.toString()}");
        // Save attendance summary to SharedPreferences
        _saveAttendanceSummary(response);
        emit(SuccessAttendanceState(response));
      },
    );
  }

  void updateIndex(int index) async {
    emit(UpdateLoadingState());
    final courses = CourseListModel().coursesList;
    if (courses.isEmpty || index >= courses.length) {
      emit(ErrorAttendanceState("Courses not loaded or invalid index"));
      return;
    }
    var result = await _layoutUseCase.call(courses[index].id.toString());
    result.fold(
      (error) {
        emit(ErrorAttendanceState(error.errorMessage));
      },
      (response) {
        if (response != report) {
          report = response;
          // Save updated attendance summary
          _saveAttendanceSummary(response);
          emit(UpdateAttendanceIndexState(response));
        } else {
          log("No data change detected, skipping emit.");
        }
      },
    );
  }

  // Method to save attendance summary to SharedPreferences
  void _saveAttendanceSummary(ReportAttendanceReportEntity report) {
    try {
      final present = report.present?.toInt() ?? 0;
      final absent = report.absent?.toInt() ?? 0;

      final summaryMap = {
        'present': present,
        'absent': absent,
        'total': present + absent,
        'rate': present > 0 ? (present / (present + absent) * 100) : 0.0
      };

      final summaryJson = jsonEncode(summaryMap);
      SharedPreferenceServices.saveData('attendanceSummary', summaryJson);
      log("Saved attendance summary: $summaryJson");
    } catch (e) {
      log("Error saving attendance summary: $e");
    }
  }
}
