import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pondrop/features/login/login.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:pondrop/features/styles/styles.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
          create: (context) {
            return LoginBloc(
              authenticationRepository:
                  RepositoryProvider.of<AuthenticationRepository>(context),
              locationRepository: RepositoryProvider.of<LocationRepository>(context),
            );
          },
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: Dims.xxLarge),
                child: SvgPicture.asset('assets/pondrop.svg'),
              ),
              Expanded(
                child: Padding(
                  padding: Dims.largeEdgeInsets,
                  child: LoginForm(),
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
