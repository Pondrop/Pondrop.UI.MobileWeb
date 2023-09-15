import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pondrop/features/login/login.dart';
import 'package:pondrop/repositories/repositories.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class MockLocationRepository extends Mock implements LocationRepository {}

void main() {
  const testEmail = 'test@test.com';
  const testPassword = 'super_secure_password';

  late AuthenticationRepository authenticationRepository;
  late LocationRepository locationRepository;

  setUp(() {
    authenticationRepository = MockAuthenticationRepository();
    locationRepository = MockLocationRepository();
  });

  group('LoginBloc', () {
    test('initial state is LoginState', () {
      expect(
          LoginBloc(
            authenticationRepository: authenticationRepository,
            locationRepository: locationRepository,
          ).state,
          equals(const LoginState()));
    });

    blocTest<LoginBloc, LoginState>(
      'emits new email when LoginEmailChanged added',
      build: () => LoginBloc(
        authenticationRepository: authenticationRepository,
        locationRepository: locationRepository,
      ),
      act: (bloc) => bloc.add(const LoginEmailChanged(testEmail)),
      expect: () => [const LoginState(email: testEmail)],
    );

    blocTest<LoginBloc, LoginState>(
      'emits new password when LoginPasswordChanged added',
      build: () => LoginBloc(
        authenticationRepository: authenticationRepository,
        locationRepository: locationRepository,
      ),
      act: (bloc) => bloc.add(const LoginPasswordChanged(testPassword)),
      expect: () => [const LoginState(password: testPassword)],
    );

    blocTest<LoginBloc, LoginState>(
      'emits new passwordObscured when LoginPasswordObscuredChanged added',
      build: () => LoginBloc(
        authenticationRepository: authenticationRepository,
        locationRepository: locationRepository,
      ),
      act: (bloc) => bloc.add(const LoginPasswordObscuredChanged(false)),
      expect: () => [const LoginState(passwordObscured: false)],
    );

    blocTest<LoginBloc, LoginState>(
      'emits new passwordObscured when LoginPasswordObscuredChanged added',
      build: () => LoginBloc(
        authenticationRepository: authenticationRepository,
        locationRepository: locationRepository,
      ),
      act: (bloc) => bloc.add(const LoginPasswordObscuredChanged(false)),
      expect: () => [const LoginState(passwordObscured: false)],
    );

    test('form submission success', () async {
      when(() => locationRepository.checkAndRequestPermissions())
          .thenAnswer((invocation) => Future.value(true));
      when(() => authenticationRepository.signIn(email: testEmail, password: testPassword))
          .thenAnswer((invocation) => Future.value('my_new_token'));

      final bloc = LoginBloc(
        authenticationRepository: authenticationRepository,
        locationRepository: locationRepository,
      );

      bloc.add(const LoginEmailChanged(testEmail));
      await bloc.stream.first;
      bloc.add(const LoginPasswordChanged(testPassword));
      await bloc.stream.first;
      bloc.add(const LoginSubmitted());
      await bloc.stream.first;

      expect(bloc.state.status, const FormSubmissionStatusSubmitting());

      await bloc.stream.first;

      expect(bloc.state.status, const FormSubmissionStatusSuccess());
    });

    test('form submission fail', () async {
      when(() => locationRepository.checkAndRequestPermissions())
          .thenAnswer((invocation) => Future.value(true));
      when(() => authenticationRepository.signIn(email: testEmail, password: testPassword))
          .thenAnswer((invocation) => Future.value(''));

      final bloc = LoginBloc(
        authenticationRepository: authenticationRepository,
        locationRepository: locationRepository,
      );

      bloc.add(const LoginEmailChanged(testEmail));
      await bloc.stream.first;
      bloc.add(const LoginPasswordChanged(testPassword));
      await bloc.stream.first;
      bloc.add(const LoginSubmitted());
      await bloc.stream.first;

      expect(bloc.state.status, const FormSubmissionStatusSubmitting());

      await bloc.stream.first;

      expect(bloc.state.status.runtimeType, (FormSubmissionStatusFailed));
    });
  });
}
