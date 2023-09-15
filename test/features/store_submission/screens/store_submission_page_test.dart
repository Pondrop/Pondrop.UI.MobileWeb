import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pondrop/api/submission_api.dart';
import 'package:pondrop/features/dialogs/dialogs.dart';
import 'package:pondrop/features/search_items/search_items.dart';
import 'package:pondrop/features/search_items/widgets/search_list_item.dart';
import 'package:pondrop/features/store_submission/widgets/fields/fields.dart';
import 'package:pondrop/features/store_submission/widgets/submission_failed_view.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:pondrop/features/store_submission/store_submission.dart';
import 'package:pondrop/features/store_submission/widgets/camera_access_view.dart';
import 'package:pondrop/features/store_submission/widgets/submission_success_view.dart';
import 'package:pondrop/features/store_submission/widgets/submission_summary_list_view.dart';
import 'package:tuple/tuple.dart';
import 'package:uuid/uuid.dart';

import '../../../fake_data/fake_data.dart';
import '../../../helpers/helpers.dart';

class MockCameraRepository extends Mock implements CameraRepository {}

class MockLocationRepository extends Mock implements LocationRepository {}

class MockSubmissionRepository extends Mock implements SubmissionRepository {}

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late CameraRepository cameraRepository;
  late LocationRepository locationRepository;
  late SubmissionRepository submissionRepository;
  late ProductRepository productRepository;

  late StoreVisitDto visit;
  late Store store;
  late StoreSubmission submission;

  setUp(() {
    cameraRepository = MockCameraRepository();
    locationRepository = MockLocationRepository();
    submissionRepository = MockSubmissionRepository();
    productRepository = MockProductRepository();

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
    visit = StoreVisitDto(
        id: const Uuid().v4(),
        storeId: store.id,
        userId: const Uuid().v4(),
        latitude: 0,
        longitude: 0);

    submission = FakeStoreSubmissionTemplates.fakeTemplates()
        .first
        .toStoreSubmission(storeVisit: visit, store: store, campaignId: null);
  });

  group('Store Submission Page', () {
    test('is routable', () {
      expect(StoreSubmissionPage.route(visit: visit, submission: submission),
          isA<MaterialPageRoute>());
    });

    testWidgets('renders camera request view', (tester) async {
      when(() => cameraRepository.isCameraEnabled())
          .thenAnswer((_) => Future.value(false));
      when(() => locationRepository.getLastKnownPosition())
          .thenAnswer((_) => Future.value(null));

      await tester.pumpApp(MultiRepositoryProvider(
          providers: [
            RepositoryProvider.value(value: submissionRepository),
            RepositoryProvider.value(value: cameraRepository),
            RepositoryProvider.value(value: locationRepository),
          ],
          child: StoreSubmissionPage(
            visit: visit,
            submission: submission,
          )));

      await tester.pumpAndSettle();

      expect(find.byType(CameraAccessView), findsOneWidget);
    });

    testWidgets('request camera access', (tester) async {
      when(() => cameraRepository.isCameraEnabled())
          .thenAnswer((_) => Future.value(false));
      when(() => cameraRepository.request())
          .thenAnswer((_) => Future.value(false));
      when(() => locationRepository.getLastKnownPosition())
          .thenAnswer((_) => Future.value(null));

      await tester.pumpApp(MultiRepositoryProvider(
          providers: [
            RepositoryProvider.value(value: submissionRepository),
            RepositoryProvider.value(value: cameraRepository),
            RepositoryProvider.value(value: locationRepository),
          ],
          child: StoreSubmissionPage(
            visit: visit,
            submission: submission,
          )));

      await tester.pumpAndSettle();
      await tester.tap(find.byKey(CameraAccessView.okayButtonKey));
      await tester.pumpAndSettle();

      verify(() => cameraRepository.request()).called(1);

      expect(find.byType(CameraAccessView), findsOneWidget);
    });

    testWidgets('renders first step dialog', (tester) async {
      when(() => cameraRepository.isCameraEnabled())
          .thenAnswer((_) => Future.value(true));
      when(() => locationRepository.getLastKnownPosition())
          .thenAnswer((_) => Future.value(null));

      await tester.pumpApp(MultiRepositoryProvider(
          providers: [
            RepositoryProvider.value(value: submissionRepository),
            RepositoryProvider.value(value: cameraRepository),
            RepositoryProvider.value(value: locationRepository),
          ],
          child: StoreSubmissionPage(
            visit: visit,
            submission: submission,
          )));

      await tester.pumpAndSettle();

      expect(find.byType(DialogPage), findsOneWidget);
      expect(find.text(submission.steps.first.instructionsContinueButton),
          findsOneWidget);
    });

    testWidgets('edit fields & render SubmissionSummaryListView',
        (tester) async {
      when(() => cameraRepository.isCameraEnabled())
          .thenAnswer((_) => Future.value(true));
      when(() => locationRepository.getLastKnownPosition())
          .thenAnswer((_) => Future.value(null));

      await tester.pumpApp(MultiRepositoryProvider(
          providers: [
            RepositoryProvider.value(value: submissionRepository),
            RepositoryProvider.value(value: cameraRepository),
            RepositoryProvider.value(value: locationRepository),
          ],
          child: StoreSubmissionPage(
            visit: visit,
            submission: submission,
          )));

      await tester.pumpAndSettle();
      await tester
          .tap(find.text(submission.steps.first.instructionsSkipButton));
      await tester.pumpAndSettle();

      final step = submission.steps[0];
      const textValue = 'Text value';
      const doubleValue = '9.9';
      const intValue = '6';

      await tester.enterText(
          find.byKey(Key(step.fields
              .firstWhere((e) => e.fieldType == SubmissionFieldType.text)
              .fieldId)),
          textValue);

      await tester.enterText(
          find.byKey(Key(step.fields
              .firstWhere((e) => e.fieldType == SubmissionFieldType.barcode)
              .fieldId)),
          '96385074');

      // Date field
      await tester.tap(find.byKey(Key(step.fields
          .firstWhere((e) => e.fieldType == SubmissionFieldType.date)
          .fieldId)));
      await tester.pump();
      expect(find.byType(CalendarDatePicker), findsOneWidget);
      await tester.tap(find.text('15'));
      await tester.tap(find.text('OK'));

      await tester.enterText(
          find.byKey(Key(step.fields
              .firstWhere((e) => e.fieldType == SubmissionFieldType.currency)
              .fieldId)),
          doubleValue);
      await tester.enterText(
          find.byKey(Key(step.fields
              .firstWhere((e) => e.fieldType == SubmissionFieldType.integer)
              .fieldId)),
          intValue);
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(StoreSubmissionPage.nextButtonKey));
      await tester.pumpAndSettle();

      expect(find.byType(SubmissionSummaryListView), findsOneWidget);
      expect(find.text(textValue), findsOneWidget);
    });

    testWidgets('submit submission success', (tester) async {
      // need at least one result
      final textField = submission.steps[0].fields
          .firstWhere((e) => e.fieldType == SubmissionFieldType.text);
      textField.results.first.stringValue = 'text value';

      when(() => cameraRepository.isCameraEnabled())
          .thenAnswer((_) => Future.value(true));
      when(() => locationRepository.getLastKnownPosition())
          .thenAnswer((_) => Future.value(null));
      when(() => locationRepository.getCurrentPosition())
          .thenAnswer((_) => Future.value(null));
      when(() => submissionRepository.submitResult(submission))
          .thenAnswer((_) => Future.value(true));

      await tester.pumpApp(MultiRepositoryProvider(
          providers: [
            RepositoryProvider.value(value: submissionRepository),
            RepositoryProvider.value(value: cameraRepository),
            RepositoryProvider.value(value: locationRepository),
          ],
          child: StoreSubmissionPage(
            visit: visit,
            submission: submission,
          )));

      await tester.pumpAndSettle();
      await tester
          .tap(find.text(submission.steps.first.instructionsSkipButton));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(StoreSubmissionPage.nextButtonKey));
      await tester.pumpAndSettle();

      expect(find.text('Send'), findsOneWidget);

      await tester.tap(find.byKey(StoreSubmissionPage.nextButtonKey));
      await tester.pumpAndSettle();

      verify(() => submissionRepository.submitResult(submission)).called(1);
      expect(find.byType(SubmissionSuccessView), findsOneWidget);
    });

    testWidgets('submit submission fails', (tester) async {
      // need at least one result
      final textField = submission.steps[0].fields
          .firstWhere((e) => e.fieldType == SubmissionFieldType.text);
      textField.results.first.stringValue = 'text value';

      when(() => cameraRepository.isCameraEnabled())
          .thenAnswer((_) => Future.value(true));
      when(() => locationRepository.getLastKnownPosition())
          .thenAnswer((_) => Future.value(null));
      when(() => locationRepository.getCurrentPosition())
          .thenAnswer((_) => Future.value(null));
      when(() => submissionRepository.submitResult(submission))
          .thenAnswer((_) => Future.value(false));

      await tester.pumpApp(MultiRepositoryProvider(
          providers: [
            RepositoryProvider.value(value: submissionRepository),
            RepositoryProvider.value(value: cameraRepository),
            RepositoryProvider.value(value: locationRepository),
          ],
          child: StoreSubmissionPage(
            visit: visit,
            submission: submission,
          )));

      await tester.pumpAndSettle();
      await tester
          .tap(find.text(submission.steps.first.instructionsSkipButton));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(StoreSubmissionPage.nextButtonKey));
      await tester.pumpAndSettle();

      expect(find.text('Send'), findsOneWidget);

      await tester.tap(find.byKey(StoreSubmissionPage.nextButtonKey));
      await tester.pumpAndSettle();

      verify(() => submissionRepository.submitResult(submission)).called(1);
      expect(find.byType(SubmissionFailedView), findsOneWidget);
    });

    testWidgets('product search', (tester) async {
      final product = FakeProduct.fakeProduct();

      when(() => cameraRepository.isCameraEnabled())
          .thenAnswer((_) => Future.value(true));
      when(() => locationRepository.getLastKnownPosition())
          .thenAnswer((_) => Future.value(null));
      when(() => productRepository.fetchProducts(any(), 0))
          .thenAnswer((_) => Future.value(Tuple2([product], false)));

      await tester.pumpApp(MultiRepositoryProvider(
          providers: [
            RepositoryProvider.value(value: submissionRepository),
            RepositoryProvider.value(value: cameraRepository),
            RepositoryProvider.value(value: locationRepository),
            RepositoryProvider.value(value: productRepository),
          ],
          child: StoreSubmissionPage(
            visit: visit,
            submission: submission,
          )));

      await tester.pumpAndSettle();
      await tester
          .tap(find.text(submission.steps.first.instructionsSkipButton));
      await tester.pumpAndSettle();

      final step = submission.steps[0];
      final searchField = step.fields.firstWhere((e) =>
          e.fieldType == SubmissionFieldType.search &&
          e.itemType == SubmissionFieldItemType.product);
      final searchButtonKey =
          SearchFieldControl.getSearchButtonKey(searchField.fieldId);

      await tester.tap(find.byKey(searchButtonKey));
      await tester.pumpAndSettle();

      expect(find.byType(SearchItemPage), findsOneWidget);

      await tester.enterText(
          find.byKey(SearchItemPage.searchTextFieldKey), 'search term');

      await tester.pump(const Duration(milliseconds: 350));

      await tester.tap(find.byType(SearchListItem));
      await tester.pumpAndSettle();

      expect(find.byKey(searchButtonKey), findsNothing);
      expect(find.text(product.name), findsOneWidget);

      await tester.tap(find.byIcon(Icons.cancel_outlined));
      await tester.pumpAndSettle();
      expect(find.byKey(searchButtonKey), findsOneWidget);
    });
  });
}
