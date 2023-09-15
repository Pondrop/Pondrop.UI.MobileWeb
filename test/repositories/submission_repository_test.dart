import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pondrop/api/submission_api.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:uuid/uuid.dart';

import '../fake_data/fake_data.dart';

class MockUserRepository extends Mock implements UserRepository {}

class MockSubmissionApi extends Mock implements SubmissionApi {}

void main() {
  final User user = User(email: 'me@email.com', accessToken: const Uuid().v4());

  late UserRepository userRepository;
  late SubmissionApi submissionApi;

  setUp(() {
    userRepository = MockUserRepository();
    submissionApi = MockSubmissionApi();

    when(() => userRepository.getUser())
        .thenAnswer((invocation) => Future<User?>.value(user));
  });

  group('SubmissionRepository', () {
    test('Construct an instance', () {
      expect(
          SubmissionRepository(
              userRepository: userRepository, submissionApi: submissionApi),
          isA<SubmissionRepository>());
    });
  });

  group('StoreRepository Templates', () {
    test('Get templates from API', () async {
      final templates = FakeStoreSubmissionTemplates.fakeTemplates();

      when(() => submissionApi.fetchTemplates(user.accessToken, false))
          .thenAnswer((invocation) => Future.value(templates));

      final repo = SubmissionRepository(
          userRepository: userRepository, submissionApi: submissionApi);

      final result = await repo.fetchTemplates();

      expect(result, templates);
    });

    test('Get templates from API - failure returns empty', () async {
      when(() => submissionApi.fetchTemplates(user.accessToken, false))
          .thenThrow(Exception());

      final repo = SubmissionRepository(
          userRepository: userRepository, submissionApi: submissionApi);

      final result = await repo.fetchTemplates();

      expect(result, const []);
    });

    test('Submit submission', () async {
      final template = FakeStoreSubmissionTemplates.fakeTemplates().first;
      final submission = template.toStoreSubmission(
          storeVisit: FakeStoreVisit.fakeVist(),
          store: FakeStore.fakeStore(),
          campaignId: const Uuid().v4());
      submission.steps.first.fields.first.results.first.stringValue =
          'test value';
      final submissionDto = submission.toSubmissionResultDto();

      when(() => submissionApi.submitResult(user.accessToken, submissionDto))
          .thenAnswer((invocation) => Future.value(null));

      final repo = SubmissionRepository(
          userRepository: userRepository, submissionApi: submissionApi);

      expect(
          repo.submissions,
          emits(predicate<StoreSubmission>((i) =>
              i.templateId == submission.templateId &&
              i.dateCreated == submission.dateCreated &&
              i.submitted)));

      final result = await repo.submitResult(submission);

      expect(result, true);
    });

    test('Submit submission - failure returns false', () async {
      final template = FakeStoreSubmissionTemplates.fakeTemplates().first;
      final submission = template.toStoreSubmission(
          storeVisit: FakeStoreVisit.fakeVist(),
          store: FakeStore.fakeStore(),
          campaignId: const Uuid().v4());
      final submissionDto = submission.toSubmissionResultDto();

      when(() => submissionApi.submitResult(user.accessToken, submissionDto))
          .thenThrow(Exception());

      final repo = SubmissionRepository(
          userRepository: userRepository, submissionApi: submissionApi);

      final result = await repo.submitResult(submission);

      expect(result, false);
    });
  });

  group('StoreRepository StoreVisit', () {
    test('Start StoreVisit', () async {
      final storeId = const Uuid().v4();
      final visit = StoreVisitDto(
          id: const Uuid().v4(),
          storeId: storeId,
          userId: const Uuid().v4(),
          latitude: 0,
          longitude: 0);

      when(() => submissionApi.startStoreVisit(user.accessToken, storeId, null))
          .thenAnswer((invocation) => Future.value(visit));

      final repo = SubmissionRepository(
          userRepository: userRepository, submissionApi: submissionApi);

      final result = await repo.startStoreVisit(storeId, null);

      expect(result, visit);
    });

    test('Start StoreVisit - failure returns null', () async {
      final storeId = const Uuid().v4();

      when(() => submissionApi.startStoreVisit(user.accessToken, storeId, null))
          .thenThrow(Exception());

      final repo = SubmissionRepository(
          userRepository: userRepository, submissionApi: submissionApi);

      final result = await repo.startStoreVisit(storeId, null);

      expect(result, null);
    });

    test('End StoreVisit', () async {
      final storeId = const Uuid().v4();
      final visit = StoreVisitDto(
          id: const Uuid().v4(),
          storeId: storeId,
          userId: const Uuid().v4(),
          latitude: 0,
          longitude: 0);

      when(() => submissionApi.endStoreVisit(user.accessToken, visit.id, null))
          .thenAnswer((invocation) => Future.value(visit));

      final repo = SubmissionRepository(
          userRepository: userRepository, submissionApi: submissionApi);

      final result = await repo.endStoreVisit(visit.id, null);

      expect(result, visit);
    });

    test('End StoreVisit - failure returns null', () async {
      final visitId = const Uuid().v4();

      when(() => submissionApi.endStoreVisit(user.accessToken, visitId, null))
          .thenThrow(Exception());

      final repo = SubmissionRepository(
          userRepository: userRepository, submissionApi: submissionApi);

      final result = await repo.endStoreVisit(visitId, null);

      expect(result, null);
    });
  });

  group('StoreRepository Campaigns', () {
    test('Get category campaigns from API', () async {
      final storeId = const Uuid().v4();
      final campaigns = FakeCampaign.fakeCategoryCampaignDtos(storeId: storeId);

      when(() =>
              submissionApi.fetchCategoryCampaigns(user.accessToken, [storeId]))
          .thenAnswer((invocation) => Future.value(campaigns.cast()));

      final repo = SubmissionRepository(
          userRepository: userRepository, submissionApi: submissionApi);

      final result = await repo.fetchCategoryCampaigns([storeId]);

      expect(result, campaigns);
    });

    test('Get category campaigns from API - failure returns empty', () async {
      final storeId = const Uuid().v4();

      when(() =>
              submissionApi.fetchCategoryCampaigns(user.accessToken, [storeId]))
          .thenThrow(Exception());

      final repo = SubmissionRepository(
          userRepository: userRepository, submissionApi: submissionApi);

      final result = await repo.fetchCategoryCampaigns([storeId]);

      expect(result, const []);
    });

    test('Get product campaigns from API', () async {
      final storeId = const Uuid().v4();
      final campaigns = FakeCampaign.fakeProductCampaignDtos(storeId: storeId);

      when(() =>
              submissionApi.fetchProductCampaigns(user.accessToken, [storeId]))
          .thenAnswer((invocation) => Future.value(campaigns.cast()));

      final repo = SubmissionRepository(
          userRepository: userRepository, submissionApi: submissionApi);

      final result = await repo.fetchProductCampaigns([storeId]);

      expect(result, campaigns);
    });

    test('Get product campaigns from API - failure returns empty', () async {
      final storeId = const Uuid().v4();

      when(() =>
              submissionApi.fetchProductCampaigns(user.accessToken, [storeId]))
          .thenThrow(Exception());

      final repo = SubmissionRepository(
          userRepository: userRepository, submissionApi: submissionApi);

      final result = await repo.fetchProductCampaigns([storeId]);

      expect(result, const []);
    });
  });
}
