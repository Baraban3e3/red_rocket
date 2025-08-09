import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:red_rocket/data/api/auth_api.dart';
import 'package:red_rocket/data/models/auth_response.dart';
import 'package:red_rocket/data/repositories/auth_repository_impl.dart';
import 'package:red_rocket/domain/entities/auth_entity.dart';

import 'auth_repository_impl_test.mocks.dart';

@GenerateMocks([AuthApi, FlutterSecureStorage])
void main() {
  late AuthRepositoryImpl repository;
  late MockAuthApi mockAuthApi;
  late MockFlutterSecureStorage mockSecureStorage;

  setUp(() {
    mockAuthApi = MockAuthApi();
    mockSecureStorage = MockFlutterSecureStorage();
    repository = AuthRepositoryImpl(mockAuthApi, mockSecureStorage);
  });

  group('login', () {
    const email = 'test@test.com';
    const password = 'password123';
    const token = 'mock_token_123';
    const username = 'test';

    test('should return AuthEntity and save token on successful login', () async {
      final authResponse = AuthResponse(token: token, username: username);
      when(mockAuthApi.login({
        'email': email,
        'password': password,
      })).thenAnswer((_) async => authResponse);

      when(mockSecureStorage.write(
        key: 'auth_token',
        value: token,
      )).thenAnswer((_) async => {});

      final result = await repository.login(email, password);

      expect(result, isA<AuthEntity>());
      expect(result.token, token);
      expect(result.username, username);

      verify(mockAuthApi.login({
        'email': email,
        'password': password,
      })).called(1);

      verify(mockSecureStorage.write(
        key: 'auth_token',
        value: token,
      )).called(1);
    });
  });
}