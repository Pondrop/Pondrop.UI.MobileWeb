import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pondrop/features/app/app.dart';
import 'package:pondrop/features/authentication/bloc/authentication_bloc.dart';
import 'package:pondrop/l10n/l10n.dart';
import 'package:pondrop/features/login/login.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:pondrop/features/splash/screens/splash_page.dart';
import 'package:pondrop/features/stores/screens/store_page.dart';
import 'package:pondrop/features/styles/styles.dart';

class App extends StatelessWidget {
  const App(
      {super.key,
      required this.authenticationRepository,
      required this.locationRepository,
      required this.userRepository,
      required this.storeRepository});

  final AuthenticationRepository authenticationRepository;
  final LocationRepository locationRepository;
  final UserRepository userRepository;
  final StoreRepository storeRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authenticationRepository),
        RepositoryProvider.value(value: userRepository),
        RepositoryProvider.value(value: const CameraRepository()),
        RepositoryProvider.value(value: locationRepository),
        RepositoryProvider.value(value: storeRepository),
        RepositoryProvider(
            create: (context) => ShoppingRepository(
                userRepository:
                    RepositoryProvider.of<UserRepository>(context))),
        RepositoryProvider(
            create: (context) => SubmissionRepository(
                userRepository:
                    RepositoryProvider.of<UserRepository>(context))),
        RepositoryProvider(
            create: (context) => ProductRepository(
                userRepository:
                    RepositoryProvider.of<UserRepository>(context))),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(
              create: (context) => AuthenticationBloc(
                    authenticationRepository: authenticationRepository,
                    userRepository: userRepository,
                  )..add(AuthenticationCheckExistingUser())),
        ],
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
          primaryColor: PondropColors.primaryColor,
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.indigo,
            accentColor: PondropColors.primaryColor,
            errorColor: PondropColors.errorColor,
          ),
          hintColor: Colors.black87,
          textTheme: TextTheme(
            headline1: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
            headline2: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
            headline3: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
            headline4: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
            headline5: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
            headline6: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
            bodyText1: const TextStyle(fontSize: 14),
            bodyText2: const TextStyle(fontSize: 12),
            caption:
                TextStyle(fontSize: 14, color: Colors.black.withOpacity(0.6)),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  backgroundColor: PondropColors.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 14))),
          textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                  textStyle: const TextStyle(
                      color: PondropColors.primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500))),
          checkboxTheme: CheckboxThemeData(
              checkColor:
                  MaterialStateProperty.all(PondropColors.primaryLightColor)),
          inputDecorationTheme: const InputDecorationTheme(
            floatingLabelStyle: TextStyle(color: PondropColors.primaryColor),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: PondropColors.primaryColor),
            ),
          ),
          textSelectionTheme: const TextSelectionThemeData(
              cursorColor: PondropColors.primaryColor),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              selectedIconTheme:
                  IconThemeData(color: PondropColors.primaryColor))),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        return AnnotatedRegion(
          value: SystemUiOverlayStyle.dark,
          child: GestureDetector(
            onTap: () {
              // Dismiss keyboard
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: LoadingOverlay(
              child: BlocListener<AuthenticationBloc, AuthenticationState>(
                listenWhen: (previous, current) =>
                    previous.status != current.status,
                listener: (context, state) {
                  switch (state.status) {
                    case AuthenticationStatus.authenticated:
                      _navigator.pushAndRemoveUntil<void>(
                        StorePage.route(),
                        (route) => false,
                      );
                      break;
                    case AuthenticationStatus.unauthenticated:
                      _navigator.pushAndRemoveUntil<void>(
                        LoginPage.route(),
                        (route) => false,
                      );
                      break;
                    case AuthenticationStatus.unknown:
                      break;
                  }
                },
                child: child,
              ),
            ),
          ),
        );
      },
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}
