import 'package:built_collection/built_collection.dart';
import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:rby/rby.dart';

final changelogParserProvider = Provider(
  (ref) => const ChangelogParser(),
  name: 'ChangelogParserProvider',
);

class ChangelogParser {
  const ChangelogParser();

  /// Reads and parses the changelog data from text files in
  /// `assets/changelogs/$flavor/$buildNumber.txt`.
  ///
  /// Returns `null` if the [buildNumber] has no associated changelog file.
  Future<ChangelogData?> parse({
    required String buildNumber,
  }) async {
    final changelogString = await _changelogString(buildNumber: buildNumber);

    if (changelogString == null) return null;

    final lines = changelogString.split('\n');
    final entryStrings = lines.where((line) => line.trim().startsWith('-'));
    final entries = _parseEntries(entryStrings);

    String? title;
    DateTime? date;
    final summary = <String>[];

    // handle non entry lines
    for (final line in lines
        .where((line) => line.isNotEmpty)
        .whereNot((line) => line.trim().startsWith('-'))
        .map((line) => line.trim())) {
      if (date == null && dateRegex.hasMatch(line)) {
        // parse date
        date = DateTime.tryParse(line);
      } else if (title == null) {
        // parse title
        title = line;
      } else {
        // parse summary
        summary.add(line);
      }
    }

    return ChangelogData(
      title: title,
      date: date,
      summary: summary.toBuiltList(),
      entries: entries,
    );
  }
}

BuiltList<ChangelogEntry> _parseEntries(Iterable<String> entryStrings) {
  final entries = <ChangelogEntry>[];

  for (final rawLine in entryStrings) {
    final line = rawLine.trim().replaceFirst('- ', '');

    final newEntry = ChangelogEntry(
      line: line,
      type: _entryTypeFromLine(line),
      subEntries: BuiltList(),
    );

    if (rawLine.startsWith(' ') && entries.isNotEmpty) {
      entries.last = entries.last.copyWith(
        subEntries: entries.last.subEntries.rebuild(
          (builder) => builder.add(newEntry),
        ),
      );
    } else {
      entries.add(newEntry);
    }
  }

  return entries.toBuiltList();
}

Future<String?> _changelogString({
  required String buildNumber,
}) async {
  String? changelogString;

  if (isFree) {
    changelogString = await rootBundle
        .loadString('assets/changelogs/free/$buildNumber.txt', cache: !isTest)
        .handleError();
  }

  return changelogString ??
      await rootBundle
          .loadString('assets/changelogs/$buildNumber.txt', cache: !isTest)
          .handleError();
}

ChangelogEntryType _entryTypeFromLine(String line) {
  if (line.startsWith('Added')) {
    return ChangelogEntryType.added;
  } else if (line.startsWith('Improved')) {
    return ChangelogEntryType.improved;
  } else if (line.startsWith('Changed')) {
    return ChangelogEntryType.changed;
  } else if (line.startsWith('Updated')) {
    return ChangelogEntryType.updated;
  } else if (line.startsWith('Fixed')) {
    return ChangelogEntryType.fixed;
  } else if (line.startsWith('Removed')) {
    return ChangelogEntryType.removed;
  } else {
    return ChangelogEntryType.other;
  }
}
