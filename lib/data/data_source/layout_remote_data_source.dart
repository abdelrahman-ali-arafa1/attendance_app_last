
import 'package:attend_app/core/Services/api_manager.dart';
import 'package:attend_app/core/Services/shared_preference_services.dart';
import 'package:attend_app/core/Utils/constant_manager.dart';
import 'package:attend_app/core/Utils/end_point.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

abstract class LayoutRemoteDataSource {
  Future<Response> sendQR(
      String studentId, String sessionId, String attendanceStatus);
  Future<Response> getAttendance(String studentId);
}

@Injectable(as: LayoutRemoteDataSource)
class LayoutRemoteDataSourceImpl implements LayoutRemoteDataSource {
  final ApiManager _apiManager;

  LayoutRemoteDataSourceImpl(this._apiManager);

  @override
  Future<Response> sendQR(
      String studentId, String sessionId, String attendanceStatus) async {
    return await _apiManager.postData(EndPoints.qrCode, body: {
      "student": studentId,
      "sessionID": sessionId,
      "attendanceStatus": attendanceStatus
    }, headers: {
      'Authorization': "Bearer ${SharedPreferenceServices.getData(AppConstants.token).toString()}",
      'Content-Type': 'application/json',
    });
  }

  @override
  Future<Response> getAttendance(String courseId) async{
    return await _apiManager.getData("${EndPoints.getAttendance}/$courseId",
    headers: {
      'Authorization': "Bearer ${SharedPreferenceServices.getData(AppConstants.token).toString()}",
    });

  }

}
