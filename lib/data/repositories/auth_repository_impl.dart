import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../api/auth_api.dart';

@Singleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthApi _authApi;
  final FlutterSecureStorage _secureStorage;
  static const _tokenKey = 'auth_token';

  AuthRepositoryImpl(this._authApi, this._secureStorage);

  @override
  Future<AuthEntity> login(String email, String password) async {
    final response = await _authApi.login({
      'email': email,
      'password': password,
    });

    await saveToken(response.token);

    return AuthEntity(
      token: response.token,
      username: response.username,
    );
  }

  @override
  Future<void> logout() async {
    await _authApi.logout();
    await clearToken();
  }


//we would validate the token with the backend in a real app
  @override
  Future<AuthEntity?> checkAuth() async {
    final token = await _secureStorage.read(key: _tokenKey);
    if (token == null) return null;
    final username = token.split('_')[2];
    return AuthEntity(token: token, username: username);
  }

  @override
  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
  }

  @override
  Future<void> clearToken() async {
    await _secureStorage.delete(key: _tokenKey);
  }
}