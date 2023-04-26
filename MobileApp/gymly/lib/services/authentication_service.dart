import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/auth_user.dart';

class AuthenticationService {
  static final String _clientId = dotenv.env['CLIENT_ID']!;
  static final String _redirectUrl = dotenv.env['REDIRECT_URL']!;
  static final String _issuer = dotenv.env['ISSUER']!;
  static final String _discoveryUrl = dotenv.env['DISCOVERY_URL']!;
  static final String _postLogoutRedirectUrl =
      dotenv.env['POST_LOGOUT_REDIRECT_URL']!;
  static final List<String> _scopes = dotenv.env['SCOPES']!.split(' ');

  static const FlutterAppAuth _appAuth = const FlutterAppAuth();

  static Future<EndSessionResponse?> logout({required String idToken}) async {
    try {
      return await _appAuth.endSession(EndSessionRequest(
        idTokenHint: idToken,
        postLogoutRedirectUrl: _postLogoutRedirectUrl,
        discoveryUrl: _discoveryUrl,
      ));
    } catch (_) {
      rethrow;
    }
  }

  static Future<AuthorizationTokenResponse?> login(
      {bool preferEphemeralSession = false}) async {
    try {
      return await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          _clientId,
          _redirectUrl,
          issuer: _issuer,
          discoveryUrl: _discoveryUrl,
          scopes: _scopes,
          preferEphemeralSession: preferEphemeralSession,
        ),
      );
    } catch (_) {
      rethrow;
    }
  }

  static Future<TokenResponse?> refresh({required String refreshToken}) async {
    try {
      final TokenResponse? result = await _appAuth.token(TokenRequest(
          _clientId, _redirectUrl,
          refreshToken: refreshToken, issuer: _issuer, scopes: _scopes));

      return result;
    } catch (_) {
      rethrow;
    }
  }

  static Future<AuthUser> getUserInfo(TokenResponse response) async {
    try {
      final http.Response httpResponse = await http.get(
          Uri.parse(dotenv.env['USERINFO_ENDPOINT']!),
          headers: <String, String>{
            'Authorization': 'Bearer ${response.accessToken}',
            'Content-Type': 'application/x-www-form-urlencoded'
          });

      return AuthUser.fromJson(json.decode(httpResponse.body));
    } catch (_) {
      rethrow;
    }
  }
}
