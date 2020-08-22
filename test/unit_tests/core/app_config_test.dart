import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harpy/core/app_config.dart';
import 'package:harpy/core/service_locator.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    app.registerLazySingleton<AppConfig>(() => AppConfig());
  });

  tearDown(app.reset);

  group('parseAppConfig', () {
    test('parses a complete app config', () async {
      ServicesBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
        'flutter/assets',
        (ByteData message) async =>
            utf8.encoder.convert(_fullAppConfig).buffer.asByteData(),
      );

      final AppConfig appConfig = app<AppConfig>();
      await appConfig.parseAppConfig();

      expect(appConfig.data, isNotNull);
      expect(appConfig.data.twitterConsumerKey, 'abcd1234');
      expect(appConfig.data.twitterConsumerSecret, 'asdfkslatejwkhfcm');
      expect(appConfig.data.sentryDsn, '143jkjrewajd');
    });

    test('ignores missing sentry entry', () async {
      ServicesBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
        'flutter/assets',
        (ByteData message) async =>
            utf8.encoder.convert(_missingSentryAppConfig).buffer.asByteData(),
      );

      final AppConfig appConfig = app<AppConfig>();
      await appConfig.parseAppConfig();

      expect(appConfig.data, isNotNull);
      expect(appConfig.data.twitterConsumerKey, 'abcd1234');
      expect(appConfig.data.twitterConsumerSecret, 'asdfkslatejwkhfcm');
      expect(appConfig.data.sentryDsn, isNull);
    });

    test('returns null if twitter config is empty', () async {
      ServicesBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
        'flutter/assets',
        (ByteData message) async =>
            utf8.encoder.convert(_emptyTwitterAppConfig).buffer.asByteData(),
      );

      final AppConfig appConfig = app<AppConfig>();
      await appConfig.parseAppConfig();

      expect(appConfig.data, isNull);
    });

    test('returns null if twitter config is missing', () async {
      ServicesBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
        'flutter/assets',
        (ByteData message) async =>
            utf8.encoder.convert(_missingTwitterAppConfig).buffer.asByteData(),
      );

      final AppConfig appConfig = app<AppConfig>();
      await appConfig.parseAppConfig();

      expect(appConfig.data, isNull);
    });
  });
}

const String _fullAppConfig = '''twitter:
  consumer_key: "abcd1234"
  consumer_secret: "asdfkslatejwkhfcm"

sentry:
  dns: "143jkjrewajd"
''';

const String _missingSentryAppConfig = '''twitter:
  consumer_key: "abcd1234"
  consumer_secret: "asdfkslatejwkhfcm"
''';

const String _emptyTwitterAppConfig = '''twitter:
  consumer_key: ""
  consumer_secret: ""

sentry:
  dns: "143jkjrewajd"
''';

const String _missingTwitterAppConfig = '''
sentry:
  dns: "143jkjrewajd"
''';
