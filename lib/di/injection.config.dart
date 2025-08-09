// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../data/api/auth_api.dart' as _i17;
import '../data/api/mock_auth_interceptor.dart' as _i358;
import '../data/repositories/auth_repository_impl.dart' as _i74;
import '../domain/repositories/auth_repository.dart' as _i800;
import '../presentation/bloc/auth/auth_bloc.dart' as _i543;
import 'register_module.dart' as _i291;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final registerModule = _$RegisterModule();
  gh.singleton<_i558.FlutterSecureStorage>(() => registerModule.secureStorage);
  gh.singleton<_i358.MockAuthInterceptor>(() => registerModule.mockInterceptor);
  gh.singleton<_i361.Dio>(() => registerModule.dio);
  gh.singleton<_i17.AuthApi>(() => registerModule.authApi);
  gh.singleton<_i800.AuthRepository>(() => _i74.AuthRepositoryImpl(
        gh<_i17.AuthApi>(),
        gh<_i558.FlutterSecureStorage>(),
      ));
  gh.factory<_i543.AuthBloc>(() => _i543.AuthBloc(gh<_i800.AuthRepository>()));
  return getIt;
}

class _$RegisterModule extends _i291.RegisterModule {}
