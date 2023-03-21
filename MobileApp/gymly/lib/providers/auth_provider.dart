import 'package:flutter/foundation.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymly/models/auth_user.dart';
import 'package:gymly/services/authentication_service.dart';

@immutable
class Authentication {
  final AuthUser? user;
  final String? accessToken;
  final String? refreshToken;
  final String? idToken;
  final DateTime? expirationDate;

  const Authentication(
      {this.user,
      this.accessToken,
      this.refreshToken,
      this.idToken,
      this.expirationDate});

  bool get isAuth {
    return accessToken != null && expirationDate!.isAfter(DateTime.now());
  }

  Authentication copyWith({
    AuthUser? user,
    String? accessToken,
    String? refreshToken,
    String? idToken,
    DateTime? expirationDate,
  }) {
    return Authentication(
      user: user ?? this.user,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      idToken: idToken ?? this.idToken,
      expirationDate: expirationDate ?? this.expirationDate,
    );
  }
}

class AuthenticationNotifier extends StateNotifier<Authentication> {
  AuthenticationNotifier() : super(Authentication());

  Future<bool> login() async {
    try {
      TokenResponse? response = await AuthenticationService.login();
      if (response != null) {
        AuthUser user = await AuthenticationService.getUserInfo(response);
        state = state.copyWith(
            user: user,
            accessToken: response.accessToken,
            refreshToken: response.refreshToken,
            idToken: response.idToken,
            expirationDate: response.accessTokenExpirationDateTime);
        return true;
      }
      return false;
    } catch (_) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await AuthenticationService.logout(idToken: state.idToken);
    state = Authentication();
  }
}

final authProvider =
    StateNotifierProvider<AuthenticationNotifier, Authentication>(
        (ref) => AuthenticationNotifier());
