import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:red_rocket/presentation/bloc/auth/auth_bloc.dart';
import 'package:red_rocket/presentation/bloc/auth/auth_state.dart';
import 'package:red_rocket/presentation/screens/login/login_screen.dart';

import 'login_screen_test.mocks.dart';

@GenerateMocks([AuthBloc])
void main() {
  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
  });

  Widget createWidgetUnderTest() {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) => MaterialApp(
        home: BlocProvider<AuthBloc>.value(
          value: mockAuthBloc,
          child: const LoginScreen(),
        ),
      ),
    );
  }

  testWidgets('shows loading indicator when login button is pressed',
      (WidgetTester tester) async {
    final controller = StreamController<AuthState>.broadcast();
    when(mockAuthBloc.stream).thenAnswer((_) => controller.stream);
    when(mockAuthBloc.state).thenReturn(const AuthState());
    
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('Login'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    when(mockAuthBloc.state).thenReturn(
      const AuthState(status: AuthStatus.loading),
    );
    controller.add(const AuthState(status: AuthStatus.loading));

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(find.text('Login'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await controller.close();
  });
}