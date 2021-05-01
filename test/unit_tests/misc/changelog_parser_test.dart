import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/misc/misc.dart';
import 'package:mockito/mockito.dart';
import 'package:package_info/package_info.dart';

class MockHarpyInfo extends Mock implements HarpyInfo {}

void main() {
  setUp(() {
    app.registerLazySingleton<HarpyInfo>(() => MockHarpyInfo());
    app.registerLazySingleton<ChangelogParser>(() => ChangelogParser());

    when(app<HarpyInfo>().packageInfo).thenReturn(
      PackageInfo(buildNumber: '14', version: '', packageName: '', appName: ''),
    );
  });

  tearDown(app.reset);

  group('changelog parser', () {
    test('parses a changelog file with single line entries', () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      ServicesBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
        'flutter/assets',
        (ByteData message) async =>
            utf8.encoder.convert(_changelog1).buffer.asByteData(),
      );

      final ChangelogData data = await app<ChangelogParser>().current(null);

      expect(data.empty, isFalse);
      expect(
        data.headerLines.length,
        equals(2),
        reason: 'invalid header lines',
      );
      expect(data.additions.length, equals(3), reason: 'invalid additions');
      expect(data.changes.length, equals(1), reason: 'invalid changes');
      expect(data.fixes.length, equals(1), reason: 'invalid fixes');
      expect(data.removals.length, equals(1), reason: 'invalid removals');
      expect(data.others.length, equals(1), reason: 'invalid others');
    });

    test('removes prefix from single line entries', () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      ServicesBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
        'flutter/assets',
        (ByteData message) async =>
            utf8.encoder.convert(_changelog1).buffer.asByteData(),
      );

      final ChangelogData data = await app<ChangelogParser>().current(null);

      expect(data.headerLines[0], equals('First header line.'));
      expect(
        data.headerLines[1],
        equals('Second header line. This is a long one.'),
      );

      expect(data.additions.first.line, equals('Added about screen'));
      expect(
        data.changes.first.line,
        equals('Changed the design for info messages'),
      );
      expect(
        data.fixes.first.line,
        equals('Fixed video player central replay button not working'),
      );
      expect(data.removals.first.line, equals('Removed my sanity'));
      expect(data.others.first.line, equals('Unrelated changelog entry'));
    });

    test('parses a changelog file with additional info entries', () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      ServicesBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
        'flutter/assets',
        (ByteData message) async =>
            utf8.encoder.convert(_changelog2).buffer.asByteData(),
      );

      final ChangelogData data = await app<ChangelogParser>().current(null);

      expect(data.additions.length, equals(2));
      expect(
        data.additions.first.line,
        equals('Added Twitter Media settings:'),
      );
      expect(data.additions.first.additionalInfo.length, equals(3));
      expect(
        data.additions.first.additionalInfo.first,
        equals('Set the quality when using WiFi'),
      );
    });

    test(
        'returns an empty changelog data object '
        'if changelog file is empty', () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      ServicesBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
        'flutter/assets',
        (ByteData message) async =>
            utf8.encoder.convert(_changelog3).buffer.asByteData(),
      );

      final ChangelogData data = await app<ChangelogParser>().current(null);

      expect(data.empty, isTrue);
    });
  });
}

const String _changelog1 = '''First header line.
Second header line. This is a long one.

· Added about screen
· Added theme selection settings with 4 predefined themes
· Added setup screen for the first login
· Changed the design for info messages
· Fixed video player central replay button not working
· Removed my sanity
· Unrelated changelog entry''';

const String _changelog2 = '''· Added Twitter Media settings:
    · Set the quality when using WiFi
    · Set the quality when using mobile data
    · Autoplay gifs
· Added launching urls when tapping a url
· Fixed animation when viewing user profiles
· Fixed Tweet animation abruptly stopping when changing scroll direction
· Removed my sanity
· Unrelated changelog entry
''';

const String _changelog3 = '''
''';
