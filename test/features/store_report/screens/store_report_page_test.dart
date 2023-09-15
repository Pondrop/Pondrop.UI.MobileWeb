import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pondrop/api/submissions/models/models.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:pondrop/features/store_report/store_report.dart';
import 'package:uuid/uuid.dart';

import '../../../fake_data/fake_data.dart';
import '../../../helpers/helpers.dart';

class MockStoreRepository extends Mock implements StoreRepository {}

class MockSubmissionRepository extends Mock implements SubmissionRepository {}

class MockLocationRepository extends Mock implements LocationRepository {}

void main() {
  late StoreRepository storeRepository;
  late SubmissionRepository submissionRepository;
  late LocationRepository locationRepository;

  late Store store;
  late StoreVisitDto storeVisitDto;

  setUp(() {
    storeRepository = MockStoreRepository();
    submissionRepository = MockSubmissionRepository();
    locationRepository = MockLocationRepository();

    store = const Store(
        id: 'ID',
        retailer: 'Superfoods',
        name: 'Seaford',
        displayName: 'Superfoods Seaford',
        address: '123 St, City',
        latitude: 0,
        longitude: 0,
        communityStore: false,
        lastKnowDistanceMetres: -1);
    storeVisitDto = StoreVisitDto(
        id: const Uuid().v4(),
        storeId: store.id,
        userId: const Uuid().v4(),
        latitude: 0,
        longitude: 0);
  });

  group('Store Report', () {
    test('is routable', () {
      expect(StoreReportPage.route(store), isA<MaterialPageRoute>());
    });

    testWidgets('renders a Store Report page', (tester) async {
      when(() => submissionRepository.submissions)
          .thenAnswer((invocation) => Stream.fromIterable([]));
      when(() => submissionRepository.startStoreVisit(any(), any()))
          .thenAnswer((invocation) => Future.value(null));
      when(() => locationRepository.getLastKnownPosition())
          .thenAnswer((invocation) => Future.value(null));

      await tester.pumpAppWithRoute((settings) {
        return MaterialPageRoute(
            settings: RouteSettings(arguments: store),
            builder: (context) {
              return MultiRepositoryProvider(providers: [
                RepositoryProvider.value(value: storeRepository),
                RepositoryProvider.value(value: submissionRepository),
                RepositoryProvider.value(value: locationRepository),
              ], child: const StoreReportPage());
            });
      });

      expect(find.text(store.displayName), findsOneWidget);
    });

    testWidgets('renders a Store Report page with Submissions', (tester) async {
      final templates = FakeStoreSubmissionTemplates.fakeTemplates();
      final submission = templates.first
          .toStoreSubmission(
              storeVisit: storeVisitDto, store: store, campaignId: null)
          .copyWith(
              result: SubmissionResultDto(
                  submissionTemplateId: templates.first.id,
                  storeVisitId: storeVisitDto.id,
                  completedDate: DateTime.now(),
                  steps: const []),
              submittedDate: DateTime.now());

      when(() => submissionRepository.fetchTemplates())
          .thenAnswer((invocation) => Future.value(templates));
      when(() => submissionRepository.submissions)
          .thenAnswer((invocation) => Stream.fromIterable([submission]));
      when(() => submissionRepository.startStoreVisit(any(), any()))
          .thenAnswer((invocation) => Future.value(null));
      when(() => locationRepository.getLastKnownPosition())
          .thenAnswer((invocation) => Future.value(null));

      await tester.pumpAppWithRoute((settings) {
        return MaterialPageRoute(
            settings: RouteSettings(arguments: store),
            builder: (context) {
              return MultiRepositoryProvider(providers: [
                RepositoryProvider.value(value: storeRepository),
                RepositoryProvider.value(value: submissionRepository),
                RepositoryProvider.value(value: locationRepository),
              ], child: const StoreReportPage());
            });
      });

      await tester.pump(const Duration(milliseconds: 350));

      expect(find.text(store.displayName), findsOneWidget);
      expect(find.text(submission.title), findsOneWidget);
      expect(find.byIcon(Icons.warning_amber_outlined), findsNothing);
    });

    testWidgets('renders a Store Report page with Campaigns', (tester) async {
      final storeVisitDto = StoreVisitDto(
          id: const Uuid().v4(),
          storeId: store.id,
          userId: const Uuid().v4(),
          latitude: 0,
          longitude: 0);

      final templates = FakeStoreSubmissionTemplates.fakeTemplates();
      final categoryCampaigns = FakeCampaign.fakeCategoryCampaignDtos(
          storeId: store.id,
          submissionTemplateId: templates.first.id,
          length: 1);
      final productCampaigns = FakeCampaign.fakeProductCampaignDtos(
          storeId: store.id,
          submissionTemplateId: templates.first.id,
          length: 1);

      when(() => submissionRepository.submissions)
          .thenAnswer((invocation) => Stream.fromIterable([]));
      when(() => submissionRepository.fetchTemplates())
          .thenAnswer((invocation) => Future.value(templates));
      when(() => submissionRepository.fetchCategoryCampaigns([store.id]))
          .thenAnswer((invocation) => Future.value(categoryCampaigns.cast()));
      when(() => submissionRepository.fetchProductCampaigns([store.id]))
          .thenAnswer((invocation) => Future.value(productCampaigns.cast()));
      when(() => submissionRepository.fetchTemplates())
          .thenAnswer((invocation) => Future.value(templates));
      when(() => submissionRepository.startStoreVisit(store.id, any()))
          .thenAnswer((invocation) => Future.value(storeVisitDto));
      when(() => locationRepository.getLastKnownPosition())
          .thenAnswer((invocation) => Future.value(null));

      await tester.pumpAppWithRoute((settings) {
        return MaterialPageRoute(
            settings: RouteSettings(arguments: store),
            builder: (context) {
              return MultiRepositoryProvider(providers: [
                RepositoryProvider.value(value: storeRepository),
                RepositoryProvider.value(value: submissionRepository),
                RepositoryProvider.value(value: locationRepository),
              ], child: const StoreReportPage());
            });
      });

      await tester.pump(const Duration(milliseconds: 350));

      expect(find.text(store.displayName), findsOneWidget);
      expect(find.text(templates.first.title), findsNWidgets(2));
      expect(find.text(categoryCampaigns.first.focusName), findsOneWidget);
      expect(find.text(productCampaigns.first.focusName), findsOneWidget);
    });
  });
}
