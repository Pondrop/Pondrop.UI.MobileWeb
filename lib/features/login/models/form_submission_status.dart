import 'package:equatable/equatable.dart';

abstract class FormSubmissionStatus extends Equatable {
  const FormSubmissionStatus();
}

class FormSubmissionStatusInitial extends FormSubmissionStatus {
  const FormSubmissionStatusInitial();

  @override
  List<Object> get props => [];
}

class FormSubmissionStatusSubmitting extends FormSubmissionStatus {
  const FormSubmissionStatusSubmitting();

  @override
  List<Object> get props => [];
}

class FormSubmissionStatusSuccess extends FormSubmissionStatus {
  const FormSubmissionStatusSuccess();

  @override
  List<Object> get props => [];
}

class FormSubmissionStatusFailed extends FormSubmissionStatus {
  const FormSubmissionStatusFailed(this.errorMessage);

  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}
