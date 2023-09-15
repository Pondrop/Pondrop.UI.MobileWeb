part of 'task_templates_bloc.dart';

abstract class TaskTemplatesEvent extends Equatable {
  @override
  List<Object> get props => [];
  
  const TaskTemplatesEvent();
}

class TaskTemplatesFetched extends TaskTemplatesEvent {
  const TaskTemplatesFetched();
}

class TaskTemplatesRefreshed extends TaskTemplatesEvent {
  const TaskTemplatesRefreshed();
}
