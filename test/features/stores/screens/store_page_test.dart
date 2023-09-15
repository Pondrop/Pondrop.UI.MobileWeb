import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pondrop/api/submissions/models/models.dart';
import 'package:pondrop/features/authentication/bloc/authentication_bloc.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:pondrop/features/stores/widgets/store_list.dart';
import 'package:pondrop/features/stores/widgets/store_list_item.dart';
import 'package:pondrop/features/stores/store.dart';
import 'package:tuple/tuple.dart';

import '../../../fake_data/fake_data.dart';
import '../../../helpers/helpers.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class MockLocationRepository extends Mock implements LocationRepository {}

class MockStoreRepository extends Mock implements StoreRepository {}

class MockSubmissionRepository extends Mock implements SubmissionRepository {}

class MockAuthenticationBloc extends Mock implements AuthenticationBloc {}

void main() {
  late AuthenticationRepository authenticationRepository;
  late LocationRepository locationRepository;
  late StoreRepository storeRepository;
  late SubmissionRepository submissionRepository;
  late AuthenticationBloc authenticationBloc;

  setUp(() {
    authenticationRepository = MockAuthenticationRepository();
    locationRepository = MockLocationRepository();
    storeRepository = MockStoreRepository();
    submissionRepository = MockSubmissionRepository();
    authenticationBloc = MockAuthenticationBloc();
  });

  group('Store', () {
    test('is routable', () {
      expect(StorePage.route(), isA<MaterialPageRoute>());
    });

    testWidgets('renders a Store List', (tester) async {
      const authState = AuthenticationState.authenticated(
          User(email: 'me@me.com', accessToken: 'let_me_in'));

      when(() => authenticationRepository.status).thenAnswer((_) =>
          Stream<AuthenticationStatus>.fromIterable(
              [AuthenticationStatus.authenticated]));
      when(() => authenticationBloc.stream).thenAnswer(
          (_) => Stream<AuthenticationState>.fromIterable([authState]));
      when(() => authenticationBloc.state).thenReturn(authState);

      await tester.pumpApp(MultiRepositoryProvider(
          providers: [
            RepositoryProvider.value(value: authenticationRepository),
            RepositoryProvider.value(value: storeRepository),
            RepositoryProvider.value(value: submissionRepository),
            RepositoryProvider.value(value: locationRepository),
          ],
          child: BlocProvider.value(
            value: authenticationBloc,
            child: const StorePage(),
          )));

      await tester.pumpAndSettle();

      expect(find.byType(StoresList), findsOneWidget);
    });

    testWidgets('renders a Store List item', (tester) async {
      const authState = AuthenticationState.authenticated(
          User(email: 'me@me.com', accessToken: 'let_me_in'));

      when(() => authenticationRepository.status).thenAnswer((_) =>
          Stream<AuthenticationStatus>.fromIterable(
              [AuthenticationStatus.authenticated]));
      when(() => authenticationBloc.stream).thenAnswer(
          (_) => Stream<AuthenticationState>.fromIterable([authState]));
      when(() => authenticationBloc.state).thenReturn(authState);
      when(() => locationRepository.getCurrentPosition())
          .thenAnswer((_) => Future.value(null));
      when(() => locationRepository.getLastKnownPosition())
          .thenAnswer((_) => Future.value(null));
      when(() => storeRepository.fetchStores(any(), any(), any())).thenAnswer(
          (_) => Future.value(Tuple2([FakeStore.fakeStore()], false)));
      when(() =>
              storeRepository.fetchCommunityStores(any(), any(), any(), top: 1))
          .thenAnswer((_) => Future.value(const Tuple2([], false)));
      when(() => submissionRepository.fetchCategoryCampaigns(any()))
          .thenAnswer((invocation) => Future.value(const []));
      when(() => submissionRepository.fetchProductCampaigns(any()))
          .thenAnswer((invocation) => Future.value(const []));

      await tester.pumpApp(MultiRepositoryProvider(
          providers: [
            RepositoryProvider.value(value: authenticationRepository),
            RepositoryProvider.value(value: storeRepository),
            RepositoryProvider.value(value: submissionRepository),
            RepositoryProvider.value(value: locationRepository),
          ],
          child: BlocProvider.value(
            value: authenticationBloc,
            child: const StorePage(),
          )));

      await tester.pump();

      expect(find.byType(StoresList), findsOneWidget);
      expect(find.byType(StoreListItem), findsOneWidget);
    });

    testWidgets('renders a Store List item with campaign count',
        (tester) async {
      const authState = AuthenticationState.authenticated(
          User(email: 'me@me.com', accessToken: 'let_me_in'));

      final stores = [FakeStore.fakeStore()];
      final storeIds = stores.map((e) => e.id).toList();
      final categoryCampaigns = FakeCampaign.fakeCategoryCampaignDtos(
              storeId: storeIds.first, length: 1)
          .whereType<CategoryCampaignDto>()
          .toList();
      final productCampaigns = FakeCampaign.fakeProductCampaignDtos(
              storeId: storeIds.first, length: 1)
          .whereType<ProductCampaignDto>()
          .toList();

      when(() => authenticationRepository.status).thenAnswer((_) =>
          Stream<AuthenticationStatus>.fromIterable(
              [AuthenticationStatus.authenticated]));
      when(() => authenticationBloc.stream).thenAnswer(
          (_) => Stream<AuthenticationState>.fromIterable([authState]));
      when(() => authenticationBloc.state).thenReturn(authState);
      when(() => locationRepository.getCurrentPosition())
          .thenAnswer((_) => Future.value(null));
      when(() => locationRepository.getLastKnownPosition())
          .thenAnswer((_) => Future.value(null));
      when(() => locationRepository.getLastKnownPosition())
          .thenAnswer((_) => Future.value(null));
      when(() => storeRepository.fetchStores(any(), any(), any()))
          .thenAnswer((invocation) => Future.value(Tuple2(stores, true)));
      when(() =>
              storeRepository.fetchCommunityStores(any(), any(), any(), top: 1))
          .thenAnswer((_) => Future.value(const Tuple2([], false)));
      when(() => submissionRepository.fetchCategoryCampaigns(storeIds))
          .thenAnswer((invocation) => Future.value(categoryCampaigns));
      when(() => submissionRepository.fetchProductCampaigns(storeIds))
          .thenAnswer((invocation) => Future.value(productCampaigns));

      await tester.pumpApp(MultiRepositoryProvider(
          providers: [
            RepositoryProvider.value(value: authenticationRepository),
            RepositoryProvider.value(value: storeRepository),
            RepositoryProvider.value(value: submissionRepository),
            RepositoryProvider.value(value: locationRepository),
          ],
          child: BlocProvider.value(
            value: authenticationBloc,
            child: const StorePage(),
          )));

      await tester.pump();

      expect(find.byType(StoresList), findsOneWidget);
      expect(find.byType(StoreListItem), findsOneWidget);
      expect(find.text('2 tasks'), findsOneWidget);
    });
  });
}
