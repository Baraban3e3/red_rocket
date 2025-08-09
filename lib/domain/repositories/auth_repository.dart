import '../entities/auth_entity.dart';

abstract class AuthRepository {
  Future<AuthEntity> login(String email, String password);
  Future<void> logout();
  Future<AuthEntity?> checkAuth();
  Future<void> saveToken(String token);
  Future<void> clearToken();
}