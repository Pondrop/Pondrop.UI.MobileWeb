import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pondrop/features/login/login.dart';
import 'package:pondrop/repositories/repositories.dart';

import '../../../helpers/helpers.dart';

class MockAuthenticationRepository extends Mock implements AuthenticationRepository {}

class MockLocationRepository extends Mock implements LocationRepository {}

void main() {
  late AuthenticationRepository authenticationRepository;
  late LocationRepository locationRepository;

  setUp(() {
    authenticationRepository = MockAuthenticationRepository();
    locationRepository = MockLocationRepository();
  });

  group('LoginPage', () {
    test('is routable', () {
      expect(LoginPage.route(), isA<MaterialPageRoute>());
    });

    testWidgets('renders a LoginForm', (tester) async {
      await tester.pumpApp(MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: authenticationRepository),
          RepositoryProvider.value(value: locationRepository),
        ],
        child: const LoginPage()
      ));
      expect(find.byType(LoginForm), findsOneWidget);
    });
  });
}
