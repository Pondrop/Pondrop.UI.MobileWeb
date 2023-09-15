part of 'login_bloc.dart';

class LoginState extends Equatable {
  const LoginState({
    this.status = const FormSubmissionStatusInitial(),
    this.email = '',
    this.password = '',
    this.passwordObscured = true,
    this.passwordMinLength = 8,
  });

  final FormSubmissionStatus status;
  final String email;
  final String password;
  final bool passwordObscured;
  final int passwordMinLength;

  bool get isEmailEmpty =>
    email.isEmpty;
  bool get isValidEmail => 
    !isEmailEmpty && EmailValidator.validate(email);

  bool get isPasswordEmpty => 
    password.isEmpty;
  bool get isValidPassword => 
    !isPasswordEmpty && password.length >= passwordMinLength;

  LoginState copyWith({
    FormSubmissionStatus? status,
    String? email,
    String? password,
    bool? passwordObscured,
    int? passwordMinLength,
  }) {
    return LoginState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
      passwordObscured: passwordObscured ?? this.passwordObscured,
      passwordMinLength: passwordMinLength ?? this.passwordMinLength,
    );
  }

  @override
  List<Object> get props => [status, email, password, passwordObscured, passwordMinLength];
}
