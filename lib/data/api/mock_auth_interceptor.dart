import 'package:dio/dio.dart';

class MockAuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final path = options.path.split('/').last;

    switch (path) {
      case 'login':
        _handleLogin(options, handler);
        break;
      case 'logout':
        _handleLogout(options, handler);
        break;
      default:
        _handleNotFound(options, handler);
    }
  }

  void _handleLogin(RequestOptions options, RequestInterceptorHandler handler) {
    try {
      if (options.data == null) {
        return _sendError(
          handler,
          options,
          'Request body is missing',
          400,
        );
      }

      if (options.data is! Map<String, dynamic>) {
        return _sendError(
          handler,
          options,
          'Invalid request format',
          400,
        );
      }

      final body = options.data as Map<String, dynamic>;
      
      if (!body.containsKey('email') || !body.containsKey('password')) {
        return _sendError(
          handler,
          options,
          'Email and password are required',
          400,
        );
      }

      final email = body['email'];
      final password = body['password'];

      if (email == null || password == null) {
        return _sendError(
          handler,
          options,
          'Email and password cannot be null',
          400,
        );
      }

      if (email is! String || password is! String) {
        return _sendError(
          handler,
          options,
          'Email and password must be strings',
          400,
        );
      }

      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(email)) {
        return _sendError(
          handler,
          options,
          'Invalid email format',
          400,
        );
      }

      if (email == 'test@test.com' && password == 'password123') {
        handler.resolve(
          Response(
            requestOptions: options,
            data: {
              'token': 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
              'username': email.split('@')[0],
            },
            statusCode: 200,
          ),
        );
      } else {
        _sendError(
          handler,
          options,
          'Invalid email or password',
          401,
        );
      }
    } catch (e) {
      _sendError(
        handler,
        options,
        'Internal server error',
        500,
      );
    }
  }

  void _handleLogout(RequestOptions options, RequestInterceptorHandler handler) {
    handler.resolve(
      Response(
        requestOptions: options,
        data: {'message': 'Successfully logged out'},
        statusCode: 200,
      ),
    );
  }

  void _handleNotFound(RequestOptions options, RequestInterceptorHandler handler) {
    _sendError(
      handler,
      options,
      'Endpoint not found',
      404,
    );
  }

  void _sendError(
    RequestInterceptorHandler handler,
    RequestOptions options,
    String message,
    int statusCode,
  ) {
    handler.resolve(
      Response(
        requestOptions: options,
        data: {
          'status': 'error',
          'message': message,
          'code': statusCode,
        },
        statusCode: statusCode,
      ),
    );
  }
}