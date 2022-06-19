import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/rby/rby.dart';
import 'package:twitter_webview_auth/twitter_webview_auth.dart';

/// Handles login.
///
/// Authentication logic is split between
/// * [authenticationProvider]
/// * [loginProvider]
/// * [logoutProvider]
final loginProvider = Provider(
  (ref) => _Login(
    read: ref.read,
    environment: ref.watch(environmentProvider),
  ),
  name: 'LoginProvider',
);

class _Login with LoggerMixin {
  const _Login({
    required Reader read,
    required Environment environment,
  })  : _read = read,
        _environment = environment;

  final Reader _read;
  final Environment _environment;

  /// Initializes a web based twitter authentication.
  ///
  /// Navigates to
  /// * [HomePage] on successful authentication
  /// * [SetupPage] on successful authentication if the setup has not yet been
  ///   completed
  /// * [LoginPage] when authentication was not successful.
  Future<void> login() async {
    if (!_environment.validateAppConfig()) {
      _read(messageServiceProvider).showText('invalid twitter key / secret');
      return;
    }

    log.fine('logging in');

    _read(authenticationStateProvider.notifier).state =
        const AuthenticationState.awaitingAuthentication();

    final result = await TwitterAuth(
      consumerKey: _environment.twitterConsumerKey,
      consumerSecret: _environment.twitterConsumerSecret,
      callbackUrl: 'harpy://',
    ).authenticateWithTwitter(
      webviewNavigation: _webviewNavigation,
    );

    await result.when(
      success: (token, secret, userId) async {
        log.fine('successfully authenticated');

        _read(authPreferencesProvider.notifier).setAuth(
          token: token,
          secret: secret,
          userId: userId,
        );

        await _read(authenticationProvider)
            .onLogin(_read(authPreferencesProvider));

        if (_read(authenticationStateProvider).isAuthenticated) {
          if (_read(setupPreferencesProvider).performedSetup) {
            _read(routerProvider).goNamed(
              HomePage.name,
              queryParams: {'origin': 'login'},
            );
          } else {
            _read(routerProvider).goNamed(SetupPage.name);
          }
        } else {
          _read(routerProvider).goNamed(LoginPage.name);
        }
      },
      failure: (e, st) {
        log.warning(
          'login failed\n\n'
          'If this issue is persistent, see\n'
          'https://github.com/robertodoering/harpy/wiki/Troubleshooting',
          e,
          st,
        );

        _read(messageServiceProvider).showSnackbar(
          const SnackBar(
            content: Text('authentication failed, please try again'),
          ),
        );

        _read(authenticationStateProvider.notifier).state =
            const AuthenticationState.unauthenticated();

        _read(routerProvider).goNamed(LoginPage.name);
      },
      cancelled: () {
        log.fine('login cancelled by user');

        _read(authenticationStateProvider.notifier).state =
            const AuthenticationState.unauthenticated();

        _read(routerProvider).goNamed(LoginPage.name);
      },
    );
  }

  /// Used by [TwitterAuth] to navigate to the login webview page.
  Future<Uri?> _webviewNavigation(TwitterLoginWebview webview) async {
    return _read(routerProvider).navigator?.push<Uri?>(
          HarpyPageRoute(
            builder: (_) => LoginWebview(webview: webview),
          ),
        );
  }
}
