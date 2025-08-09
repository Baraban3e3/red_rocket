import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import '../data/api/auth_api.dart';
import '../data/api/mock_auth_interceptor.dart';

@module
abstract class RegisterModule {
  @singleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();

  @singleton
  MockAuthInterceptor get mockInterceptor => MockAuthInterceptor();

  @singleton
  Dio get dio => Dio(
        BaseOptions(
          baseUrl: 'http://127.0.0.1',
          connectTimeout: const Duration(seconds: 1),
          receiveTimeout: const Duration(seconds: 1),
          sendTimeout: const Duration(seconds: 1),
        ),
      )..interceptors.addAll([
          mockInterceptor,
          LogInterceptor(requestBody: true, responseBody: true),
        ]);

  @singleton
  AuthApi get authApi => AuthApi(dio);
}