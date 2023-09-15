import 'package:bloc/bloc.dart';
import 'package:email_validator/email_validator.dart';
import 'package:equatable/equatable.dart';
import 'package:pondrop/features/login/models/form_submission_status.dart';
import 'package:pondrop/repositories/repositories.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required AuthenticationRepository authenticationRepository,
    required LocationRepository locationRepository,
  })  : _authenticationRepository = authenticationRepository,
        _locationRepository = locationRepository,
        super(const LoginState()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginPasswordObscuredChanged>(_onLoginPasswordObscuredChanged);
    on<LoginSubmitted>(_onSubmitted);
  }

  final AuthenticationRepository _authenticationRepository;
  final LocationRepository _locationRepository;

  void _onEmailChanged(
    LoginEmailChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(
      email: event.email,
      passwordObscured: true,
    ));
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(
      password: event.password,
      passwordObscured: true,
    ));
  }

  void _onLoginPasswordObscuredChanged(
    LoginPasswordObscuredChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(
      passwordObscured: event.passwordObscured,
    ));
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (state.isValidEmail) {
      await _locationRepository.checkAndRequestPermissions();

      emit(state.copyWith(status: const FormSubmissionStatusSubmitting()));
      
      try {
        final emailTrimmed = state.email.trim();
        final tok = await _authenticationRepository.signIn(
          email: emailTrimmed,
          password: state.password,
        );

        if (tok.isNotEmpty) {
          emit(state.copyWith(status: const FormSubmissionStatusSuccess()));
        }
        else {
          emit(state.copyWith(status: const FormSubmissionStatusFailed('Could not validate email. Please try again.')));
        }
      } catch (e) {
        emit(state.copyWith(status: FormSubmissionStatusFailed(e.toString())));
      }
    }
  }
}
