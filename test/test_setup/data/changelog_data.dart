import 'package:built_collection/built_collection.dart';
import 'package:harpy/components/components.dart';

final changelogFull = ChangelogData(
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

final changelogRich = ChangelogData(
  title: 'Version header',
  date: DateTime(2022, 7, 29),
  summary: [
    'Check out harpy on [GitHub](https://github.com/robertodoering/harpy)!',
  ].toBuiltList(),
  entries: [
    ChangelogEntry(
      line: 'Added feature thanks ([@harpy_app](user/harpy_app))',
      type: ChangelogEntryType.added,
      subEntries: [
        ChangelogEntry(
          line: 'In `settings › general`',
          type: ChangelogEntryType.other,
          subEntries: BuiltList(),
        ),
      ].toBuiltList(),
    ),
  ].toBuiltList(),
);

final changelogOnlyEntries = ChangelogData(
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

final changelogOnlyTitle = ChangelogData(
  title: 'Version 1337',
  date: null,
  summary: BuiltList(),
  entries: BuiltList(),
);

final changelogOnlyDate = ChangelogData(
  title: null,
  date: DateTime(1999, 9, 9),
  summary: BuiltList(),
  entries: BuiltList(),
);

final changelogTitleAndSummary = ChangelogData(
  title: 'New awesome update #v1.234.5',
  date: null,
  summary: ['This changelog has no entries.'].toBuiltList(),
  entries: BuiltList(),
);
