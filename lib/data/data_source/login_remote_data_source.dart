import 'package:attend_app/core/Services/api_manager.dart';
import 'package:attend_app/core/Utils/end_point.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

abstract class LoginRemoteDataSource {
  Future<Response> login(String username, String password);
}
@Injectable(as: LoginRemoteDataSource)
class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
final ApiManager _apiManager;
 LoginRemoteDataSourceImpl(this._apiManager);
  @override
  Future<Response> login(String username, String password) async {
    return await _apiManager.postData(
      EndPoints.login,
      body: {
        'username': username,
        'password': password
      }
    );
  }
}