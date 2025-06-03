// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../core/Services/api_manager.dart' as _i694;
import '../data/data_source/layout_remote_data_source.dart' as _i961;
import '../data/data_source/login_remote_data_source.dart' as _i990;
import '../data/repository_impl/Layout_repository_impl.dart' as _i891;
import '../data/repository_impl/login_repository_impl.dart' as _i458;
import '../domain/repository/layout_repository.dart' as _i493;
import '../domain/repository/login_repository.dart' as _i719;
import '../domain/use_case/layout_use_case.dart' as _i344;
import '../domain/use_case/login_use_case.dart' as _i772;
import '../ui/layout/manager/attendance_cubit/attendance_view_model.dart'
    as _i440;
import '../ui/layout/manager/scan_qr_cubit/scan_qr_view_model.dart' as _i764;
import '../ui/login_screen/manager/login_view_model.dart' as _i403;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.singleton<_i694.ApiManager>(() => _i694.ApiManager());
    gh.factory<_i990.LoginRemoteDataSource>(
        () => _i990.LoginRemoteDataSourceImpl(gh<_i694.ApiManager>()));
    gh.factory<_i961.LayoutRemoteDataSource>(
        () => _i961.LayoutRemoteDataSourceImpl(gh<_i694.ApiManager>()));
    gh.factory<_i719.LoginRepository>(
        () => _i458.LoginRepositoryImpl(gh<_i990.LoginRemoteDataSource>()));
    gh.factory<_i493.LayoutRepository>(
        () => _i891.LayoutRepositoryImpl(gh<_i961.LayoutRemoteDataSource>()));
    gh.factory<_i772.LoginUseCase>(
        () => _i772.LoginUseCase(gh<_i719.LoginRepository>()));
    gh.factory<_i403.LoginViewModel>(
        () => _i403.LoginViewModel(gh<_i772.LoginUseCase>()));
    gh.factory<_i344.LayoutUseCase>(
        () => _i344.LayoutUseCase(gh<_i493.LayoutRepository>()));
    gh.factory<_i440.AttendanceViewModel>(
        () => _i440.AttendanceViewModel(gh<_i344.LayoutUseCase>()));
    gh.factory<_i764.AttendanceCubit>(
        () => _i764.AttendanceCubit(gh<_i344.LayoutUseCase>()));
    return this;
  }
}
