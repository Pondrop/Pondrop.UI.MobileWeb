import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:uuid/uuid.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late MockFlutterSecureStorage secureStorage;

  setUp(() {
    secureStorage = MockFlutterSecureStorage();
  });

  group('UserRepository', () {
    test('Construct an instance', () {
      expect(
          UserRepository(secureStorage: secureStorage), isA<UserRepository>());
    });

    test('GetUser', () async {
      final user = User(email: 'me@email.com', accessToken: const Uuid().v4());
      final userJson = jsonEncode(user.toJson());

      when(() => secureStorage.read(key: UserRepository.userKey))
          .thenAnswer((invocation) => Future.value(userJson));

      final repo = UserRepository(secureStorage: secureStorage);

      final result = await repo.getUser();

      expect(result, user);
    });

    test('SetUser', () async {
      final user = User(email: 'me@email.com', accessToken: const Uuid().v4());
      final userJson = jsonEncode(user.toJson());

      when(() =>
              secureStorage.write(key: UserRepository.userKey, value: userJson))
          .thenAnswer((invocation) => Future.value(null));

      final repo = UserRepository(secureStorage: secureStorage);

      await repo.setUser(user);

      verify(() =>
              secureStorage.write(key: UserRepository.userKey, value: userJson))
          .called(1);
    });

    test('ClearUser', () async {
      when(() => secureStorage.delete(key: UserRepository.userKey))
          .thenAnswer((invocation) => Future.value(null));

      final repo = UserRepository(secureStorage: secureStorage);

      await repo.clearUser();

      verify(() => secureStorage.delete(key: UserRepository.userKey)).called(1);
    });
  });
}
