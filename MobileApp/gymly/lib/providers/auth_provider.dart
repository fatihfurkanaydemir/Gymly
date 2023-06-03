import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gymly/models/auth_user.dart';
import 'package:gymly/providers/storage_provider.dart';
import 'package:gymly/services/authentication_service.dart';

@immutable
class Authentication {
  final AuthUser? user;
  final bool? isFirstLogin;
  final String? accessToken;
  final String? refreshToken;
  final String? idToken;
  final DateTime? accessTokenExprDateTime;
  final DateTime? refreshTokenExprDateTime;

  const Authentication({
    this.user,
    this.accessToken,
    this.refreshToken,
    this.idToken,
    this.accessTokenExprDateTime,
    this.refreshTokenExprDateTime,
    this.isFirstLogin,
  });

  bool get isAuth {
    return accessToken != null &&
        refreshToken != null &&
        refreshTokenExprDateTime!.isAfter(DateTime.now());
  }

  Authentication copyWith(
      {AuthUser? user,
      String? accessToken,
      String? refreshToken,
      String? idToken,
      DateTime? accessTokenExprDateTime,
      DateTime? refreshTokenExprDateTime,
      bool? isFirstLogin}) {
    return Authentication(
      user: user ?? this.user,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      idToken: idToken ?? this.idToken,
      accessTokenExprDateTime:
          accessTokenExprDateTime ?? this.accessTokenExprDateTime,
      refreshTokenExprDateTime:
          refreshTokenExprDateTime ?? this.refreshTokenExprDateTime,
      isFirstLogin: isFirstLogin ?? this.isFirstLogin,
    );
  }
}

class AuthenticationNotifier extends StateNotifier<Authentication> {
  FlutterSecureStorage _storage;

  AuthenticationNotifier(this._storage) : super(Authentication()) {
    // Timer.periodic(const Duration(minutes: 8), (timer) {
    //   refresh();
    // });
  }

  Future<String> getAccessToken() async {
    await refresh();
    return state.accessToken!;
  }

  Future<bool> login() async {
    try {
      TokenResponse? response = await AuthenticationService.login();
      if (response != null) {
        final isFirstLogin =
            await AuthenticationService.checkUserCreated(response);

        AuthUser user = await AuthenticationService.getUserInfo(response);
        DateTime refreshExpiresDateTime = DateTime.fromMillisecondsSinceEpoch(
            DateTime.now().millisecondsSinceEpoch +
                int.parse(response
                        .tokenAdditionalParameters!["refresh_expires_in"]) *
                    1000);

        state = state.copyWith(
          user: user,
          accessToken: response.accessToken,
          refreshToken: response.refreshToken,
          idToken: response.idToken,
          accessTokenExprDateTime: response.accessTokenExpirationDateTime,
          refreshTokenExprDateTime: refreshExpiresDateTime,
          isFirstLogin: isFirstLogin,
        );

        await _storage.write(key: "refreshToken", value: response.refreshToken);
        await _storage.write(
            key: "refreshTokenExprDateTime",
            value: refreshExpiresDateTime.toIso8601String());
        return true;
      }
      return false;
    } catch (_) {
      rethrow;
    }
  }

  void cancelFirstLogin() {
    state = state.copyWith(isFirstLogin: false);
  }

  Future<void> logout() async {
    await AuthenticationService.logout(idToken: state.idToken!);
    await _storage.delete(key: "refreshToken");
    await _storage.delete(key: "refreshTokenExprDateTime");
    await _storage.delete(key: "accessToken");
    state = Authentication();
  }

  Future<bool> refresh({String? refreshToken, bool useStorage = false}) async {
    try {
      final response = await AuthenticationService.refresh(
          refreshToken: refreshToken ?? state.refreshToken!);
      if (response == null) {
        state = Authentication();
        return false;
      }

      AuthUser user =
          state.user ?? await AuthenticationService.getUserInfo(response);

      DateTime refreshExpiresDateTime = DateTime.fromMillisecondsSinceEpoch(
          DateTime.now().millisecondsSinceEpoch +
              int.parse(response
                      .tokenAdditionalParameters!["refresh_expires_in"]) *
                  1000);

      state = state.copyWith(
        user: user,
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
        idToken: response.idToken,
        accessTokenExprDateTime: response.accessTokenExpirationDateTime,
        refreshTokenExprDateTime: refreshExpiresDateTime,
      );

      await _storage.write(key: "refreshToken", value: response.refreshToken);
      await _storage.write(
          key: "refreshTokenExprDateTime",
          value: refreshExpiresDateTime.toIso8601String());

      if (useStorage) {
        await _storage.write(key: "accessToken", value: response.accessToken);
      }

      return true;
    } catch (_) {
      rethrow;
    }
  }
}

final authProvider =
    StateNotifierProvider<AuthenticationNotifier, Authentication>(
        (ref) => AuthenticationNotifier(ref.read(storageProvider)));
