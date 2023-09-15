import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pondrop/extensions/extensions.dart';

class AuthApi {
  AuthApi({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  static const _authority = 'auth-service.ashyocean-bde16918.australiaeast.azurecontainerapps.io';
  static const Map<String, String> _requestHeaders = {
    'Content-type': 'application/json',
  };

  final http.Client _httpClient;
 
  Future<String> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _httpClient.post(
      Uri.https(_authority, '/Auth/shopper/signin'),
      headers: _requestHeaders,
      body: jsonEncode(<String, String>{
        'email' : email
      }));

    response.ensureSuccessStatusCode();
   
    final decodedBody = jsonDecode(response.body);
    final accessToken = decodedBody['accessToken'] as String? ?? '';

    return accessToken;
  }

  Future<void> signOut(String accessToken) {
    return _httpClient.post(
      Uri.https(_authority, '/Auth/shopper/signout'),
      headers: { 'Authorization' : 'Bearer $accessToken' });
  }
}
