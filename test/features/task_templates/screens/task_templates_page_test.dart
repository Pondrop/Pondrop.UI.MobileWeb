import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pondrop/api/submissions/models/models.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:pondrop/features/task_templates/task_templates.dart';
import 'package:pondrop/features/task_templates/widgets/task_templates.dart';

import '../../../fake_data/fake_data.dart';
import '../../../helpers/helpers.dart';

class MockSubmissionRepository extends Mock implements SubmissionRepository {}

void main() {
  late SubmissionRepository submissionRepository;
  late List<SubmissionTemplateDto> templates;

  setUp(() {
    submissionRepository = MockSubmissionRepository();
    templates = FakeStoreSubmissionTemplates.fakeTemplates();
  });

  group('Task Templates Page', () {
    test('is routable', () {
      expect(
          TaskTemplatesPage.route(
              FakeStoreVisit.fakeVist(), FakeStore.fakeStore()),
          isA<PageRoute>());
    });

    testWidgets('renders TaskTemplates', (tester) async {
      when(() => submissionRepository.fetchTemplates(useCachedResult: true))
          .thenAnswer((invocation) => Future.value(templates));

      await tester.pumpApp(MultiRepositoryProvider(
          providers: [
            RepositoryProvider.value(value: submissionRepository),
          ],
          child: TaskTemplatesPage(
            visit: FakeStoreVisit.fakeVist(),
            store: FakeStore.fakeStore(),
          )));

      expect(find.byType(TaskTemplates), findsOneWidget);
    });

    testWidgets('renders TaskTemplates empty', (tester) async {
      when(() => submissionRepository.fetchTemplates(useCachedResult: true))
          .thenAnswer((invocation) => Future.value([]));

      await tester.pumpApp(MultiRepositoryProvider(
          providers: [
            RepositoryProvider.value(value: submissionRepository),
          ],
          child: TaskTemplatesPage(
            visit: FakeStoreVisit.fakeVist(),
            store: FakeStore.fakeStore(),
          )));

      expect(find.byType(ListView), findsNothing);
    });
  });
}
