part of 'task_templates_bloc.dart';

enum TaskTemplateStatus { initial, refreshing, success, failure }

class TaskTemplatesState extends Equatable {
  const TaskTemplatesState({
    this.status = TaskTemplateStatus.initial,
    this.templates = const <SubmissionTemplateDto>[],
  });

  final TaskTemplateStatus status;
  final List<SubmissionTemplateDto> templates;

  TaskTemplatesState copyWith({
    TaskTemplateStatus? status,
    List<SubmissionTemplateDto>? templates,
  }) {
    return TaskTemplatesState(
      status: status ?? this.status,
      templates: templates ?? this.templates,
    );
  }

  @override
  String toString() {
    return '''TaskTemplatesState { status: $status, templates: ${templates.length} }''';
  }

  @override
  List<Object> get props => [status, templates];
}
