import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:red_rocket/domain/entities/auth_entity.dart';
import 'package:red_rocket/domain/repositories/auth_repository.dart';
import 'package:red_rocket/presentation/bloc/auth/auth_bloc.dart';
import 'package:red_rocket/presentation/bloc/auth/auth_event.dart';
import 'package:red_rocket/presentation/bloc/auth/auth_state.dart';

import 'auth_bloc_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late AuthBloc authBloc;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    authBloc = AuthBloc(mockAuthRepository);
  });

  tearDown(() {
    authBloc.close();
  });

  group('LoginRequested', () {
    const email = 'test@test.com';
    const password = 'password123';
    const token = 'mock_token_123';
    const username = 'test';

    test('emits [loading, authenticated] when login is successful', () async {
      when(mockAuthRepository.login(email, password))
          .thenAnswer((_) async => AuthEntity(token: token, username: username));

      expect(
        authBloc.stream,
        emitsInOrder([
          const AuthState(status: AuthStatus.loading),
          const AuthState(
            status: AuthStatus.authenticated,
            username: username,
          ),
        ]),
      );

      authBloc.add(LoginRequested(email: email, password: password));
    });

    test('emits [loading, error] when login fails', () async {
      when(mockAuthRepository.login(email, password))
          .thenThrow(Exception('Login failed'));

      expect(
        authBloc.stream,
        emitsInOrder([
          const AuthState(status: AuthStatus.loading),
          const AuthState(
            status: AuthStatus.error,
            errorMessage: 'Wrong email or password',
          ),
        ]),
      );

      authBloc.add(LoginRequested(email: email, password: password));
    });
  });
}