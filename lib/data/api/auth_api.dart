import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/auth_response.dart';

part 'auth_api.g.dart';

@RestApi()
abstract class AuthApi {
  factory AuthApi(
    Dio dio, {
    String? baseUrl,
    ParseErrorLogger? errorLogger,
  }) = _AuthApi;

  @POST('login')
  Future<AuthResponse> login(@Body() Map<String, dynamic> body);

  @POST('logout')
  Future<void> logout();
}