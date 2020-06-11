import 'dart:async';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:harpy/components/authentication/bloc/authentication/authentication_bloc.dart';
import 'package:harpy/components/authentication/bloc/authentication/authentication_state.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:yaml/yaml.dart';

@immutable
abstract class AuthenticationEvent {
  Stream<AuthenticationState> applyAsync({
    AuthenticationState currentState,
    AuthenticationBloc bloc,
  });
}

class InitializeTwitterSessionEvent extends AuthenticationEvent {
  final Logger _log = Logger('InitializeTwitterSessionEvent');

  /// Parses the app configuration located at `assets/config/app_config.yaml`
  /// and returns it as an [AppConfig] object.
  ///
  /// Returns `null` if the app config was unable to be parsed or if the twitter
  /// configuration is invalid.
  Future<AppConfig> _parseAppConfig() async {
    _log.fine('parsing app config');

    try {
      final String appConfigString = await rootBundle.loadString(
        'assets/config/app_config.yaml',
      );

      // parse app config
      final YamlMap yamlMap = loadYaml(appConfigString);

      final AppConfig appConfig = AppConfig(
        twitterConsumerKey: yamlMap['twitter']['consumer_key'],
        twitterConsumerSecret: yamlMap['twitter']['consumer_secret'],
      );

      if (appConfig.invalidTwitterConfig) {
        throw Exception('Twitter api key or secret is empty.');
      } else {
        return appConfig;
      }
    } catch (e, stacktrace) {
      _log.severe(
        'Error while loading app_config.yaml\n'
        'Make sure an `app_config.yaml` file exists in the `assets/config/` '
        'directory with the twitter api key and secret.\n'
        'example:\n'
        'assets/config/app_config.yaml:\n'
        'twitter:\n'
        '    consumer_key: <key>\n'
        '    consumer_secret: <secret>',
        e,
        stacktrace,
      );
    }

    return null;
  }

  @override
  Stream<AuthenticationState> applyAsync({
    AuthenticationState currentState,
    AuthenticationBloc bloc,
  }) async* {
    final AppConfig appConfig = await _parseAppConfig();

    if (appConfig != null) {
      // init twitter login
      bloc.twitterLogin = TwitterLogin(
        consumerKey: 'consumerKey',
        consumerSecret: 'consumerSecret',
      );

      // init active twitter session
      bloc.twitterSession = await bloc.twitterLogin.currentSession;

      _log.fine('twitter session initialized');

      bloc.sessionInitialization.complete(bloc.twitterSession != null);
    }

    if (bloc.twitterSession != null) {
      yield const AuthenticatedState();
    } else {
      yield const UnauthenticatedState();
    }
  }
}

class LogoutEvent extends AuthenticationEvent {
  final Logger _log = Logger('LogoutEvent');
  @override
  Stream<AuthenticationState> applyAsync({
    AuthenticationState currentState,
    AuthenticationBloc bloc,
  }) async* {
    _log.fine('logging out');

    await bloc.twitterLogin.logOut();
    bloc.twitterSession = null;

    yield const UnauthenticatedState();
  }
}

@immutable
class AppConfig {
  const AppConfig({
    @required this.twitterConsumerKey,
    @required this.twitterConsumerSecret,
  });

  final String twitterConsumerKey;
  final String twitterConsumerSecret;

  bool get invalidTwitterConfig =>
      twitterConsumerKey?.isNotEmpty == true &&
      twitterConsumerSecret?.isNotEmpty == true;
}
