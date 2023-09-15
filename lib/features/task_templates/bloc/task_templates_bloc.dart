import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pondrop/api/submissions/models/models.dart';
import 'package:pondrop/repositories/repositories.dart';

part 'task_templates_event.dart';
part 'task_templates_state.dart';

class TaskTemplatesBloc extends Bloc<TaskTemplatesEvent, TaskTemplatesState> {
  TaskTemplatesBloc({required SubmissionRepository submissionRepository})
      : _submissionRepository = submissionRepository,
        super(const TaskTemplatesState()) {
    on<TaskTemplatesFetched>(_onTemplatesFetched);
    on<TaskTemplatesRefreshed>(_onTemplatesRefreshed);
  }

  final SubmissionRepository _submissionRepository;

  Future<void> _onTemplatesFetched(
    TaskTemplatesFetched event,
    Emitter<TaskTemplatesState> emit,
  ) async {
    if (state.status == TaskTemplateStatus.initial) {
      await _loadTemplates(emit);
    }
  }

  Future<void> _onTemplatesRefreshed(
    TaskTemplatesRefreshed event,
    Emitter<TaskTemplatesState> emit,
  ) async {
    if (state.status != TaskTemplateStatus.initial &&
        state.status != TaskTemplateStatus.refreshing) {
      emit(state.copyWith(status: TaskTemplateStatus.refreshing));
      await _loadTemplates(emit);
    }
  }

  Future<void> _loadTemplates(Emitter<TaskTemplatesState> emit) async {
    try {
      final templates =
          (await _submissionRepository.fetchTemplates(useCachedResult: true))
              .where((e) => e.manualEnabled)
              .toList();
      emit(state.copyWith(
          status: TaskTemplateStatus.success, templates: templates));
    } on Exception {
      emit(state.copyWith(status: TaskTemplateStatus.failure));
    }
  }
}
