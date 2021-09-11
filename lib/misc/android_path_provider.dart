import 'dart:async';

import 'package:flutter/services.dart';

class AndroidPathProvider {
  AndroidPathProvider._();

  static const MethodChannel _channel = MethodChannel('android_path_provider');

  /// get alarms path.
  static Future<String> get alarmsPath async {
    return await _channel.invokeMethod<String>('getAlarmsPath') ?? '';
  }

  /// get DCIM path.
  static Future<String> get dcimPath async {
    return await _channel.invokeMethod<String>('getDCIMPath') ?? '';
  }

  /// get Documents path.
  static Future<String> get documentsPath async {
    return await _channel.invokeMethod<String>('getDocumentsPath') ?? '';
  }

  /// get Downloads path.
  static Future<String> get downloadsPath async {
    return await _channel.invokeMethod<String>('getDownloadsPath') ?? '';
  }

  /// get Movies path.
  static Future<String> get moviesPath async {
    return await _channel.invokeMethod<String>('getMoviesPath') ?? '';
  }

  /// get Music path.
  static Future<String> get musicPath async {
    return await _channel.invokeMethod<String>('getMusicPath') ?? '';
  }

  /// get Notifications path.
  static Future<String> get notificationsPath async {
    return await _channel.invokeMethod<String>('getNotificationsPath') ?? '';
  }

  /// get Pictures path.
  static Future<String> get picturesPath async {
    return await _channel.invokeMethod<String>('getPicturesPath') ?? '';
  }

  /// get Podcasts path.
  static Future<String> get podcastsPath async {
    return await _channel.invokeMethod<String>('getPodcastsPath') ?? '';
  }

  /// get Ringtones path.
  static Future<String> get ringtonesPath async {
    return await _channel.invokeMethod<String>('getRingtonesPath') ?? '';
  }
}
