import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pondrop/api/submission_api.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:pondrop/features/store_report/bloc/store_report_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../fake_data/fake_data.dart';

class MockLocationRepository extends Mock implements LocationRepository {}

class MockSubmissionRepository extends Mock implements SubmissionRepository {}

void main() {
  late LocationRepository locationRepository;
  late SubmissionRepository submissionRepository;
  late Store store;
  late Position position;
  late StoreVisitDto storeVisitDto;

  const latitude = 33.8688;
  const longitude = 151.2093;

  setUp(() {
    locationRepository = MockLocationRepository();
    submissionRepository = MockSubmissionRepository();
    store = FakeStore.fakeStore();
    position = Position(
        latitude: latitude,
        longitude: longitude,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0);
    storeVisitDto = StoreVisitDto(
        id: const Uuid().v4(),
        storeId: store.id,
        userId: const Uuid().v4(),
        latitude: latitude,
        longitude: longitude);
  });

  group('StoreReportBloc', () {
    test('initial state is Initial', () {
      when(() => submissionRepository.submissions)
          .thenAnswer((invocation) => Stream.fromIterable([]));
      when(() => locationRepository.getLastKnownPosition())
          .thenAnswer((invocation) => Future.delayed(const Duration(days: 1)));

      final bloc = StoreReportBloc(
        store: store,
        submissionRepository: submissionRepository,
        locationRepository: locationRepository,
      );

      expect(bloc.state, equals(StoreReportState(store: store)));
    });

    test('create StoreVisit success', () async {
      when(() => submissionRepository.submissions)
          .thenAnswer((invocation) => Stream.fromIterable([]));
      when(() => submissionRepository.fetchTemplates())
          .thenAnswer((invocation) => Future.value([]));
      when(() => submissionRepository.startStoreVisit(store.id, any()))
          .thenAnswer((invocation) => Future.value(storeVisitDto));
      when(() => locationRepository.getLastKnownPosition())
          .thenAnswer((invocation) => Future.value(position));

      final bloc = StoreReportBloc(
        store: store,
        submissionRepository: submissionRepository,
        locationRepository: locationRepository,
      );

      await Future.delayed(const Duration(milliseconds: 100));

      verify(() => submissionRepository.startStoreVisit(store.id, any()))
          .called(1);
      verify(() => submissionRepository.fetchTemplates()).called(1);
      verify(() => locationRepository.getLastKnownPosition()).called(1);

      expect(bloc.state.visit, storeVisitDto);
      expect(bloc.state.status, StoreReportStatus.loaded);
    });

    test('create StoreVisit failed', () async {
      when(() => submissionRepository.submissions)
          .thenAnswer((invocation) => Stream.fromIterable([]));
      when(() => submissionRepository.startStoreVisit(store.id, any()))
          .thenAnswer((invocation) => Future.value(null));
      when(() => locationRepository.getLastKnownPosition())
          .thenAnswer((invocation) => Future.value(position));

      final bloc = StoreReportBloc(
        store: store,
        submissionRepository: submissionRepository,
        locationRepository: locationRepository,
      );

      await Future.delayed(const Duration(milliseconds: 100));

      expect(bloc.state.visit, null);
      expect(bloc.state.status, StoreReportStatus.failed);
    });

    test('fetch Campaigns success', () async {
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
          .thenAnswer((invocation) => Future.value(position));

      final bloc = StoreReportBloc(
        store: store,
        submissionRepository: submissionRepository,
        locationRepository: locationRepository,
      );

      await Future.delayed(const Duration(milliseconds: 100));

      verify(() => submissionRepository.startStoreVisit(store.id, any()))
          .called(1);
      verify(() => submissionRepository.fetchTemplates()).called(1);
      verify(() => locationRepository.getLastKnownPosition()).called(1);

      expect(bloc.state.visit, storeVisitDto);
      expect(bloc.state.templates, templates);
      expect(bloc.state.campaigns, [...categoryCampaigns, ...productCampaigns]);
      expect(bloc.state.status, StoreReportStatus.loaded);
    });

    test('Submission created', () async {
      final templates = FakeStoreSubmissionTemplates.fakeTemplates();
      final storeSubmission = templates.first
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
          .thenAnswer((invocation) => Stream.fromIterable([storeSubmission]));
      when(() => submissionRepository.startStoreVisit(store.id, any()))
          .thenAnswer((invocation) => Future.value(storeVisitDto));
      when(() => locationRepository.getLastKnownPosition())
          .thenAnswer((invocation) => Future.value(position));

      final bloc = StoreReportBloc(
        store: store,
        submissionRepository: submissionRepository,
        locationRepository: locationRepository,
      );

      await Future.delayed(const Duration(milliseconds: 100));

      expect(bloc.state.visit, storeVisitDto);
      expect(bloc.state.status, StoreReportStatus.loaded);
      expect(bloc.state.templates, templates);
      expect(bloc.state.submissions, [storeSubmission]);
    });

    test('close', () async {
      final templates = FakeStoreSubmissionTemplates.fakeTemplates();

      when(() => submissionRepository.fetchTemplates())
          .thenAnswer((invocation) => Future.value(templates));
      when(() => submissionRepository.submissions)
          .thenAnswer((invocation) => Stream.fromIterable([]));
      when(() => submissionRepository.startStoreVisit(store.id, any()))
          .thenAnswer((invocation) => Future.value(storeVisitDto));
      when(() => submissionRepository.endStoreVisit(storeVisitDto.id, any()))
          .thenAnswer((invocation) => Future.value(storeVisitDto));
      when(() => locationRepository.getLastKnownPosition())
          .thenAnswer((invocation) => Future.value(position));

      final bloc = StoreReportBloc(
        store: store,
        submissionRepository: submissionRepository,
        locationRepository: locationRepository,
      );

      await Future.delayed(const Duration(milliseconds: 100));

      await bloc.close();

      verify(() => submissionRepository.endStoreVisit(storeVisitDto.id, any()))
          .called(1);
    });

    test('Submission hasPending', () async {
      final templates = FakeStoreSubmissionTemplates.fakeTemplates();
      final storeSubmission = templates.first.toStoreSubmission(
          storeVisit: storeVisitDto, store: store, campaignId: null);

      when(() => submissionRepository.fetchTemplates())
          .thenAnswer((invocation) => Future.value(templates));
      when(() => submissionRepository.submissions)
          .thenAnswer((invocation) => Stream.fromIterable([storeSubmission]));
      when(() => submissionRepository.startStoreVisit(store.id, any()))
          .thenAnswer((invocation) => Future.value(storeVisitDto));
      when(() => locationRepository.getLastKnownPosition())
          .thenAnswer((invocation) => Future.value(position));

      final bloc = StoreReportBloc(
        store: store,
        submissionRepository: submissionRepository,
        locationRepository: locationRepository,
      );

      await Future.delayed(const Duration(milliseconds: 100));

      expect(bloc.state.submissions.first.submitted, false);
      expect(bloc.state.pendingSubmissions, [storeSubmission]);
      expect(bloc.state.pendingSubmissionCount, 1);
      expect(bloc.state.hasPendingSubmissions, true);
    });

    test('Submission retry pending', () async {
      final templates = FakeStoreSubmissionTemplates.fakeTemplates();
      final storeSubmission = templates.first.toStoreSubmission(
          storeVisit: storeVisitDto, store: store, campaignId: null);

      when(() => submissionRepository.fetchTemplates())
          .thenAnswer((invocation) => Future.value(templates));
      when(() => submissionRepository.submissions)
          .thenAnswer((invocation) => Stream.fromIterable([storeSubmission]));
      when(() => submissionRepository.startStoreVisit(store.id, any()))
          .thenAnswer((invocation) => Future.value(storeVisitDto));
      when(() => locationRepository.getLastKnownPosition())
          .thenAnswer((invocation) => Future.value(position));
      when(() => submissionRepository.submitResult(storeSubmission))
          .thenAnswer((invocation) => Future.value(true));

      final bloc = StoreReportBloc(
        store: store,
        submissionRepository: submissionRepository,
        locationRepository: locationRepository,
      );

      await Future.delayed(const Duration(milliseconds: 100));
      bloc.add(const StoreReportRetryPending());
      await Future.delayed(const Duration(milliseconds: 100));

      verify(() => submissionRepository.submitResult(storeSubmission))
          .called(1);
    });
  });
}
