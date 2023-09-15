import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pondrop/features/global/global.dart';
import 'package:pondrop/l10n/l10n.dart';
import 'package:pondrop/features/login/login.dart';
import 'package:pondrop/features/styles/styles.dart';

class LoginForm extends StatelessWidget {
  LoginForm({super.key});

  static const emailInputKey = Key('LoginForm_Email_Input');
  static const passwordInputKey = Key('LoginForm_Password_Input');
  static const submitButtonKey = Key('LoginForm_Submit_Input');

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        final formStatus = state.status;
        if (formStatus is FormSubmissionStatusFailed) {
          _showSnackBar(context, formStatus.errorMessage);
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.getStarted,
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: Dims.medium),
            Text(
              l10n.enterValidEmailToContinue,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            const SizedBox(height: Dims.xLarge),
            _emailField(),
            const SizedBox(
              height: Dims.medium,
            ),
            const TsAndCs(),
            //const Padding(padding: EdgeInsets.all(Dims.medium)),
            //_passwordField(),
            //const Padding(padding: EdgeInsets.all(Dims.medium)),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dims.medium, vertical: Dims.small),
              child: Center(
                child: Text(
                  l10n.agreeToTandCs,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            _loginButton(),
          ],
        ),
      ),
    );
  }

  Widget _emailField() {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        final l10n = context.l10n;

        return TextFormField(
          key: emailInputKey,
          initialValue: state.email,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: l10n.email,
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) => state.isValidEmail ? null : l10n.emailInvalid,
          onChanged: (value) =>
              context.read<LoginBloc>().add(LoginEmailChanged(value)),
          enabled: state.status != const FormSubmissionStatusSubmitting(),
        );
      },
      buildWhen: (o, n) => o.email != n.email || o.status != n.status,
    );
  }

  Widget _passwordField() {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        final l10n = context.l10n;

        return TextFormField(
          key: passwordInputKey,
          initialValue: state.password,
          obscureText: state.passwordObscured,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: Icon(
                state.passwordObscured
                    ? Icons.visibility
                    : Icons.visibility_off,
              ),
              onPressed: () => context
                  .read<LoginBloc>()
                  .add(LoginPasswordObscuredChanged(!state.passwordObscured)),
            ),
            labelText: l10n.password,
          ),
          validator: (value) =>
              state.isPasswordEmpty ? l10n.passwordCannotBeEmpty : null,
          onChanged: (value) =>
              context.read<LoginBloc>().add(LoginPasswordChanged(value)),
        );
      },
      buildWhen: (o, n) =>
          o.password != n.password || o.passwordObscured != n.passwordObscured,
    );
  }

  Widget _loginButton() {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        final l10n = context.l10n;
        final formStatus = state.status;

        if (formStatus is FormSubmissionStatusSubmitting) {
          return const Center(child: CircularProgressIndicator());
        } else if (formStatus is FormSubmissionStatusSuccess) {
          return const Center(
              child: Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 48,
          ));
        } else {
          return SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              key: submitButtonKey,
              onPressed: !state.isEmailEmpty
                  ? () {
                      final currentState = _formKey.currentState;
                      if (currentState != null && currentState.validate()) {
                        context.read<LoginBloc>().add(const LoginSubmitted());
                      }
                    }
                  : null,
              child: Text(l10n.loginPageButtonText),
            ),
          );
        }
      },
      buildWhen: (o, n) => o.email != n.email || o.status != n.status,
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
