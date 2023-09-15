import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pondrop/api/submissions/models/submission_template_dto.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:pondrop/features/task_templates/bloc/task_templates_bloc.dart';

import '../../../fake_data/fake_store_submission_templates.dart';

class MockSubmissionRepository extends Mock implements SubmissionRepository {}

void main() {
  late SubmissionRepository submissionRepository;
  late List<SubmissionTemplateDto> templates;

  setUp(() {
    submissionRepository = MockSubmissionRepository();
    templates = FakeStoreSubmissionTemplates.fakeTemplates();
  });

  group('TaskTemplatesBloc', () {
    test('initial state is TaskTemplatesState', () {
      expect(
          TaskTemplatesBloc(submissionRepository: submissionRepository).state,
          equals(const TaskTemplatesState()));
    });

    blocTest<TaskTemplatesBloc, TaskTemplatesState>(
      'emits templates when TaskTemplatesFetched added',
      setUp: () {
        when(() => submissionRepository.fetchTemplates(useCachedResult: true))
            .thenAnswer((invocation) => Future.value(templates));
      },
      build: () =>
          TaskTemplatesBloc(submissionRepository: submissionRepository),
      act: (bloc) => bloc.add(const TaskTemplatesFetched()),
      expect: () => [
        TaskTemplatesState(
            status: TaskTemplateStatus.success, templates: templates)
      ],
    );

    blocTest<TaskTemplatesBloc, TaskTemplatesState>(
      'emits error when TaskTemplatesFetched throws',
      setUp: () {
        when(() => submissionRepository.fetchTemplates(useCachedResult: true))
            .thenThrow(Exception());
      },
      build: () =>
          TaskTemplatesBloc(submissionRepository: submissionRepository),
      act: (bloc) => bloc.add(const TaskTemplatesFetched()),
      expect: () =>
          [const TaskTemplatesState(status: TaskTemplateStatus.failure)],
    );

    test('emits templates when TaskTemplatesRefreshed added', () async {
      when(() => submissionRepository.fetchTemplates(useCachedResult: true))
          .thenAnswer((invocation) => Future.value(templates));

      final bloc =
          TaskTemplatesBloc(submissionRepository: submissionRepository);

      bloc.add(const TaskTemplatesFetched());

      await bloc.stream.first;

      bloc.add(const TaskTemplatesRefreshed());

      await bloc.stream.first;

      expect(
          bloc.state,
          TaskTemplatesState(
              status: TaskTemplateStatus.refreshing, templates: templates));

      await bloc.stream.first;

      expect(
          bloc.state,
          TaskTemplatesState(
              status: TaskTemplateStatus.success, templates: templates));
    });

    test('emits error when TaskTemplatesRefreshed throws', () async {
      when(() => submissionRepository.fetchTemplates(useCachedResult: true))
          .thenAnswer((invocation) => Future.value(templates));

      final bloc =
          TaskTemplatesBloc(submissionRepository: submissionRepository);

      bloc.add(const TaskTemplatesFetched());

      await bloc.stream.first;

      when(() => submissionRepository.fetchTemplates(useCachedResult: true))
          .thenThrow(Exception());

      bloc.add(const TaskTemplatesRefreshed());

      await bloc.stream.first;

      expect(
          bloc.state,
          TaskTemplatesState(
              status: TaskTemplateStatus.failure, templates: templates));
    });
  });
}
