import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pondrop/features/app/app.dart';
import 'package:pondrop/features/login/screens/login_page.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:pondrop/features/stores/screens/store_page.dart';

class MockAuthenticationRepository extends Mock implements AuthenticationRepository {}

class MockLocationRepository extends Mock implements LocationRepository {}

class MockUserRepository extends Mock implements UserRepository {}

class MockStoreRepository extends Mock implements StoreRepository {}

void main() {
  late AuthenticationRepository authenticationRepository;
  late LocationRepository locationRepository;
  late UserRepository userRepository;
  late StoreRepository storeRepository;

  setUp(() {
    authenticationRepository = MockAuthenticationRepository();
    locationRepository = MockLocationRepository();
    userRepository = MockUserRepository();
    storeRepository = MockStoreRepository();
  });

  group('App', () {      
    testWidgets('renders LoginPage when unauthenticated', (tester) async {
      when(() => authenticationRepository.status)
        .thenAnswer((_) => 
          Stream<AuthenticationStatus>
            .fromIterable([AuthenticationStatus.unauthenticated]));
      when(() => userRepository.getUser())
        .thenAnswer((_) => Future<User?>(() => null));

      await tester.pumpWidget(App(
        authenticationRepository: authenticationRepository,
        locationRepository: locationRepository,
        userRepository: userRepository,
        storeRepository: storeRepository
      ));

      await tester.pumpAndSettle();
      expect(find.byType(LoginPage), findsOneWidget);
    });

    testWidgets('renders StorePage when authenticated', (tester) async {
      const user = User(email: 'dummy@email.com', accessToken: 'let_me_in');

      when(() => authenticationRepository.status)
        .thenAnswer((_) => 
          Stream<AuthenticationStatus>
            .fromIterable([
              AuthenticationStatus.authenticated
            ]));
      when(() => userRepository.getUser())
        .thenAnswer((_) => Future<User?>(() => user));
      
      await tester.pumpWidget(App(
        authenticationRepository: authenticationRepository,
        locationRepository: locationRepository,
        userRepository: userRepository,
        storeRepository: storeRepository
      ));

      await tester.pumpAndSettle();
      expect(find.byType(StorePage), findsOneWidget);
    });
  });
}
