import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(const AuthState()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(state.copyWith(status: AuthStatus.loading));
      
      final auth = await _authRepository.login(
        event.email,
        event.password,
      );
      
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        username: auth.username,
        errorMessage: null,
      ));
    } on DioException catch (e) {
      String errorMessage = 'An error occurred';
      if (e.response?.data != null && e.response?.data is Map) {
        final data = e.response?.data as Map;
        if (data['message'] is String && data['message']!.isNotEmpty) {
          errorMessage = data['message'];
        }
      }
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: errorMessage,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Wrong email or password',
      ));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(state.copyWith(status: AuthStatus.loading));
      
      await _authRepository.logout();
      
      emit(const AuthState(status: AuthStatus.unauthenticated));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Failed to logout, please try again',
      ));
    }
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final auth = await _authRepository.checkAuth();
      if (auth != null) {
        emit(state.copyWith(
          status: AuthStatus.authenticated,
          username: auth.username,
        ));
      } else {
        emit(const AuthState(status: AuthStatus.unauthenticated));
      }
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Failed to check auth status',
      ));
    }
  }
}