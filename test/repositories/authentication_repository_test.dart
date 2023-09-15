import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pondrop/api/auth_api.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:uuid/uuid.dart';

class MockUserRepository extends Mock implements UserRepository {}

class MockAuthApi extends Mock implements AuthApi {}

void main() {
  late MockUserRepository userRepository;
  late MockAuthApi authApi;

  setUp(() {
    userRepository = MockUserRepository();
    authApi = MockAuthApi();
  });

  group('AuthenticationRepository', () {
    test('Construct an instance', () {
      expect(
          AuthenticationRepository(
              userRepository: userRepository, authApi: authApi),
          isA<AuthenticationRepository>());
    });

    test('SignIn', () async {
      const email = 'me@email.com';
      const password = 'password123';

      final tok = const Uuid().v4();
      final user = User(email: email, accessToken: tok);

      when(() => authApi.signIn(email: email, password: password))
          .thenAnswer((invocation) => Future.value(tok));
      when(() => userRepository.getUser())
          .thenAnswer((invocation) => Future.value(user));
      when(() => userRepository.setUser(user))
          .thenAnswer((invocation) => Future.value(null));

      final repo = AuthenticationRepository(
          userRepository: userRepository, authApi: authApi);

      final result = await repo.signIn(email: email, password: password);

      verify(() => userRepository.setUser(user)).called(1);

      expect(repo.status, emits(AuthenticationStatus.authenticated));
      expect(result, tok);
    });

    test('SignOut', () async {
      final tok = const Uuid().v4();

      when(() => authApi.signOut(tok))
          .thenAnswer((invocation) => Future.value(null));
      when(() => userRepository.clearUser())
          .thenAnswer((invocation) => Future.value(null));
      when(() => userRepository.getUser())
          .thenAnswer((invocation) => Future.value(null));

      final repo = AuthenticationRepository(
          userRepository: userRepository, authApi: authApi);

      await repo.signOut(tok);

      verify(() => userRepository.clearUser()).called(1);

      expect(repo.status, emits(AuthenticationStatus.unauthenticated));
    });
  });
}
