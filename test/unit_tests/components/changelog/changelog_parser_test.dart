import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harpy/components/components.dart';

void main() {
  group('changelog parser', () {
    test('parses a full changelog', () async {
      _mockChangelog(_changelogFull);
      final data = await const ChangelogParser().parse(buildNumber: '');

      final expectedData = ChangelogData(
        title: 'Version header',
        date: DateTime(2022, 7, 29),
        summary: [
          'First summary line.',
          'Second summary line that is a bit longer than the first one.',
        ].toBuiltList(),
        entries: [
          ChangelogEntry(
            line: 'Added about screen',
            type: ChangelogEntryType.added,
            subEntries: BuiltList(),
          ),
          ChangelogEntry(
            line: 'Improved stuff',
            type: ChangelogEntryType.improved,
            subEntries: BuiltList(),
          ),
          ChangelogEntry(
            line: 'Updated existing stuff',
            type: ChangelogEntryType.updated,
            subEntries: BuiltList(),
          ),
          ChangelogEntry(
            line: 'Changed the design for info messages',
            type: ChangelogEntryType.changed,
            subEntries: BuiltList(),
          ),
          ChangelogEntry(
            line: 'Fixed video player central replay button not working',
            type: ChangelogEntryType.fixed,
            subEntries: BuiltList(),
          ),
          ChangelogEntry(
            line: 'Removed nothing',
            type: ChangelogEntryType.removed,
            subEntries: BuiltList(),
          ),
          ChangelogEntry(
            line: 'Added even more',
            type: ChangelogEntryType.added,
            subEntries: BuiltList(),
          ),
          ChangelogEntry(
            line: 'Unrelated changelog entry',
            type: ChangelogEntryType.other,
            subEntries: BuiltList(),
          ),
        ].toBuiltList(),
      );

      expect(data, expectedData);
    });

    test('parses changelog with only entries and subentries', () async {
      _mockChangelog(_changelogOnlyEntries);
      final data = await const ChangelogParser().parse(buildNumber: '');

      final expected = ChangelogData(
        title: null,
        date: null,
        summary: BuiltList(),
        entries: [
          ChangelogEntry(
            line: 'Added Twitter Media settings:',
            type: ChangelogEntryType.added,
            subEntries: [
              ChangelogEntry(
                line: 'Set the quality when using WiFi',
                type: ChangelogEntryType.other,
                subEntries: BuiltList(),
              ),
              ChangelogEntry(
                line: 'Set the quality when using mobile data',
                type: ChangelogEntryType.other,
                subEntries: BuiltList(),
              ),
              ChangelogEntry(
                line: 'Autoplay gifs',
                type: ChangelogEntryType.other,
                subEntries: BuiltList(),
              ),
            ].toBuiltList(),
          ),
          ChangelogEntry(
            line: 'Added launching urls when tapping a url',
            type: ChangelogEntryType.added,
            subEntries: BuiltList(),
          ),
          ChangelogEntry(
            line: 'Fixed animation when viewing user profiles',
            type: ChangelogEntryType.fixed,
            subEntries: BuiltList(),
          ),
          ChangelogEntry(
            line: 'Fixed Tweet animation abruptly stopping when changing '
                'scroll direction',
            type: ChangelogEntryType.fixed,
            subEntries: BuiltList(),
          ),
          ChangelogEntry(
            line: 'Unrelated changelog entry',
            type: ChangelogEntryType.other,
            subEntries: BuiltList(),
          ),
        ].toBuiltList(),
      );

      expect(data, expected);
    });

    test('parses changelog with only a title', () async {
      _mockChangelog(_changelogOnlyTitle);
      final data = await const ChangelogParser().parse(buildNumber: '');

      final expected = ChangelogData(
        title: 'Version 1337',
        date: null,
        summary: BuiltList(),
        entries: BuiltList(),
      );

      expect(data, expected);
    });

    test('parses changelog with only date', () async {
      _mockChangelog(_changelogOnlyDate);
      final data = await const ChangelogParser().parse(buildNumber: '');

      final expected = ChangelogData(
        title: null,
        date: DateTime(1999, 9, 9),
        summary: BuiltList(),
        entries: BuiltList(),
      );

      expect(data, expected);
    });

    test('parses changelog with title and summary', () async {
      _mockChangelog(_changelogTitleAndSummary);
      final data = await const ChangelogParser().parse(buildNumber: '');

      final expected = ChangelogData(
        title: 'New awesome update #v1.234.5',
        date: null,
        summary: ['This changelog has no entries.'].toBuiltList(),
        entries: BuiltList(),
      );

      expect(data, expected);
    });

    test('parses empty changelog', () async {
      _mockChangelog(_changelogEmpty);
      final data = await const ChangelogParser().parse(buildNumber: '');

      final expected = ChangelogData(
        title: null,
        date: null,
        summary: BuiltList(),
        entries: BuiltList(),
      );

      expect(data, expected);
    });
  });
}

void _mockChangelog(String changelog) {
  TestWidgetsFlutterBinding.ensureInitialized();
  ServicesBinding.instance!.defaultBinaryMessenger.setMockMessageHandler(
    'flutter/assets',
    (message) async => utf8.encoder.convert(changelog).buffer.asByteData(),
  );
}

const _changelogFull = '''
Version header
2022-07-29

First summary line.
Second summary line that is a bit longer than the first one.

- Added about screen
- Improved stuff
- Updated existing stuff
- Changed the design for info messages
- Fixed video player central replay button not working
- Removed nothing
- Added even more
- Unrelated changelog entry''';

const _changelogOnlyEntries = '''
- Added Twitter Media settings:
  - Set the quality when using WiFi
  - Set the quality when using mobile data
  - Autoplay gifs
- Added launching urls when tapping a url
- Fixed animation when viewing user profiles
- Fixed Tweet animation abruptly stopping when changing scroll direction
- Unrelated changelog entry
''';

const _changelogOnlyTitle = '''
Version 1337
''';

const _changelogOnlyDate = '''
1999-09-09
''';

const _changelogTitleAndSummary = '''
New awesome update #v1.234.5

This changelog has no entries.
''';

const _changelogEmpty = '''
''';
