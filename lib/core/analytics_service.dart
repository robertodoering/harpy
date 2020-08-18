import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

/// Wraps the [FirebaseAnalytics] to only log events when the app is built in
/// release mode and to provide an api for custom events and user properties.
class AnalyticsService {
  final FirebaseAnalytics analytics = FirebaseAnalytics();

  static final Logger _log = Logger('AnalyticsService');

  /// Logs a custom Flutter Analytics event in release mode.
  Future<void> _logEvent({
    @required String name,
    Map<String, dynamic> parameters,
  }) async {
    if (kReleaseMode) {
      _log.fine('logging analytics event: $name with $parameters');
      await analytics.logEvent(name: name, parameters: parameters);
    } else {
      _log.fine('not logging analytics event: $name with $parameters '
          'in debug mode');
    }
  }

  /// Sets a user property to a given value in release mode.
  Future<void> _setUserProperty(String name, String value) async {
    if (kReleaseMode) {
      _log.fine('settings analytics user property: $name with $value');
      await analytics.setUserProperty(name: name, value: value);
    } else {
      _log.fine('not settings analytics userproperty: $name with $value '
          'in debug mode');
    }
  }

  /// Logs the id of the currently selected theme as a user property.
  Future<void> logThemeId(int id) async {
    await _setUserProperty('theme_id', '$id');
  }

  /// Logs the name of the theme that has been chosen in the setup screen as a
  /// user property.
  Future<void> logSetupTheme(String name) async {
    await _setUserProperty('setup_theme', name);
  }
}

final Logger _log = Logger('FirebaseAnalyticsObserver');

/// The [ScreenNameExtractor] used by the [FirebaseAnalyticsObserver] to log the
/// current screen with the [FirebaseAnalytics].
///
/// Only returns the [settings.name] when in release mode.
/// Otherwise returns `null` to prevent logging analytics when not in release
/// mode.
String screenNameExtractor(RouteSettings settings) {
  final String name = settings.name;

  if (name == null) {
    return null;
  }

  _log.fine('set current screen to $name');

  if (kReleaseMode) {
    return name;
  } else {
    return null;
  }
}
