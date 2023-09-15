import 'dart:async';
import 'dart:developer';

import 'package:pondrop/api/auth_api.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/repositories/repositories.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  AuthenticationRepository(
      {required UserRepository userRepository, AuthApi? authApi})
      : _userRepository = userRepository,
        _authApi = authApi ?? AuthApi();

  final UserRepository _userRepository;
  final AuthApi _authApi;
  final _controller = StreamController<AuthenticationStatus>();

  Stream<AuthenticationStatus> get status async* {
    final user = await _userRepository.getUser();
    yield user?.accessToken.isNotEmpty == true
        ? AuthenticationStatus.authenticated
        : AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  Future<String> signIn({
    required String email,
    required String password,
  }) async {
    final accessToken = await _authApi.signIn(email: email, password: password);

    if (accessToken.isNotEmpty) {
      await _userRepository
          .setUser(User(email: email, accessToken: accessToken));
      _controller.add(AuthenticationStatus.authenticated);
    }

    return accessToken;
  }

  Future<void> signOut(String accessToken) async {
    try {
      await _authApi.signOut(accessToken);
    } catch (e) {
      log(e.toString());
    }
    await _userRepository.clearUser();
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() => _controller.close();
}
