import 'dart:developer';

import 'package:attend_app/domain/use_case/layout_use_case.dart';
import 'package:attend_app/ui/layout/manager/attendance_cubit/attendance_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/modals/course_list_model.dart';
import '../../../../domain/entity/ReportAttendanceReportEntity.dart';

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
        emit(SuccessAttendanceState(response));
      },
    );
  }

  void updateIndex(int index) async{
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
        emit(UpdateAttendanceIndexState(response));
      } else {
        log("No data change detected, skipping emit.");
      }
    },
    );
  }
}
