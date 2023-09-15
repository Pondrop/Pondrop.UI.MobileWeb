import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pondrop/features/login/login.dart';
import 'package:pondrop/repositories/repositories.dart';

import '../../../helpers/helpers.dart';

class MockAuthenticationRepository extends Mock implements AuthenticationRepository {}

class MockLoginBloc extends MockBloc<LoginEvent, LoginState> implements LoginBloc {}

void main() {
  const testEmail = 'test@test.com';
  const testPassword = 'super_secure_password';

  late AuthenticationRepository authenticationRepository;

  setUp(() {
    authenticationRepository = MockAuthenticationRepository();
  });

  group('LoginForm', () {
    late LoginBloc loginBloc;

    setUp(() {
      loginBloc = MockLoginBloc();
    });

    testWidgets('adds LoginEmailChanged to LoginBloc when email updated',
    (tester) async {  
      when(() => loginBloc.state).thenReturn(const LoginState());

      await tester.pumpApp(
        BlocProvider.value(
          value: loginBloc,
          child: Scaffold(body: LoginForm()),
        ),
      );

      await tester.enterText(
        find.byKey(LoginForm.emailInputKey),
        testEmail,
      );
      
      verify(() => 
        loginBloc.add(const LoginEmailChanged(testEmail)),
      ).called(1);
    });

    testWidgets('loading indicator shown when status is submitting',
    (tester) async {
      when(() => loginBloc.state)
        .thenReturn(const LoginState(status: FormSubmissionStatusSubmitting()));

      await tester.pumpApp(
        BlocProvider.value(
          value: loginBloc,
          child: Scaffold(body: LoginForm()),
        ),
      );

      expect(find.byType(ElevatedButton), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('login button disabled when empty',
    (tester) async {
      when(() => loginBloc.state)
        .thenReturn(const LoginState(
          status: FormSubmissionStatusInitial(),
          email: ''));

      await tester.pumpApp(
        BlocProvider.value(
          value: loginBloc,
          child: Scaffold(body: LoginForm()),
        ),
      );

      expect(tester.widget<ElevatedButton>(find.byType(ElevatedButton)).enabled, isFalse);
    });

    testWidgets('does not add LoginSubmitted to LoginBloc when submitted & invalid',
    (tester) async {
      when(() => loginBloc.state)
        .thenReturn(const LoginState(
          status: FormSubmissionStatusInitial(),
          email: 'not_a_valid_email'));

      await tester.pumpApp(
        BlocProvider.value(
          value: loginBloc,
          child: Scaffold(body: LoginForm()),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      verifyNever(() => loginBloc.add(const LoginSubmitted()));
    });

    testWidgets('adds LoginSubmitted to LoginBloc when submitted & valid',
    (tester) async {
      when(() => loginBloc.state)
        .thenReturn(const LoginState(email: testEmail, password: testPassword));

      await tester.pumpApp(
        BlocProvider.value(
          value: loginBloc,
          child: Scaffold(body: LoginForm()),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      verify(() => loginBloc.add(const LoginSubmitted())).called(1);
    });

    testWidgets('show SnackBar when submission failure',
    (tester) async {
      const errMsg = 'BOOM 💥';

      whenListen(
        loginBloc,
        Stream.fromIterable([
          const LoginState(status: FormSubmissionStatusSubmitting()),
          const LoginState(status: FormSubmissionStatusFailed(errMsg)),
        ]),
      );
      when(() => loginBloc.state).thenReturn(
        const LoginState(status: FormSubmissionStatusFailed(errMsg)),
      );

      await tester.pumpApp(
        BlocProvider.value(
          value: loginBloc,
          child: Scaffold(body: LoginForm()),
        ),
      );

      expect(find.byType(SnackBar), findsNothing);
      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text(errMsg), findsOneWidget);
    });
  });
}
