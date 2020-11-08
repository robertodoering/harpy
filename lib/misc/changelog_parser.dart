import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:harpy/core/harpy_info.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/harpy.dart';

/// Parses the [ChangelogData] from a changelog file located in
/// `android/fastlane/metadata/android/$flavor/en-US/changelogs/$versionCode.txt`.
class ChangelogParser {
  static const String linePrefix = '· ';

  /// Returns the [ChangelogData] for the current version.
  ///
  /// Returns `null` if the current version has no changelog file.
  Future<ChangelogData> current() async {
    return parse(app<HarpyInfo>().packageInfo.buildNumber);
  }

  /// Returns the [ChangelogData] for the [versionCode].
  ///
  /// Returns `null` if no corresponding changelog file exists.
  Future<ChangelogData> parse(String versionCode) async {
    try {
      final String changelogString = await rootBundle.loadString(
        _changelogString(versionCode),
        cache: false,
      );

      final ChangelogData data = ChangelogData(versionCode: versionCode);

      ChangelogEntry entry;

      for (String line in changelogString.split('\n')) {
        line = line.replaceFirst(linePrefix, '');

        if (line.trim().isEmpty) {
          continue;
        }

        if (line.startsWith(' ') && entry != null) {
          // additional information for the last line
          entry?.additionalInfo?.add(line.trim());
        } else if (line.startsWith('Added')) {
          entry = _parseLine(line);
          data.additions.add(entry);
        } else if (line.startsWith('Changed')) {
          entry = _parseLine(line);
          data.changes.add(entry);
        } else if (line.startsWith('Fixed')) {
          entry = _parseLine(line);
          data.fixes.add(entry);
        } else if (line.startsWith('Removed')) {
          entry = _parseLine(line);
          data.removals.add(entry);
        } else {
          entry = _parseLine(line);
          data.others.add(entry);
        }
      }

      return data;
    } catch (e) {
      // changelog file not found
      return null;
    }
  }

  String _changelogString(String versionCode) {
    final String flavor = Harpy.isFree ? 'free' : 'pro';

    return 'android/fastlane/metadata/android'
        '/$flavor/en-US/changelogs/$versionCode.txt';
  }

  ChangelogEntry _parseLine(String line) {
    return ChangelogEntry(line: line.trim());
  }
}

/// Represents the data of a changelog for one version.
class ChangelogData {
  ChangelogData({
    this.versionCode,
  });

  final String versionCode;

  /// Entries that start with 'Added'.
  final List<ChangelogEntry> additions = <ChangelogEntry>[];

  /// Entries that start with 'Changed'.
  final List<ChangelogEntry> changes = <ChangelogEntry>[];

  /// Entries that start with 'Fixed'.
  final List<ChangelogEntry> fixes = <ChangelogEntry>[];

  /// Entries that start with 'Removed'.
  final List<ChangelogEntry> removals = <ChangelogEntry>[];

  /// Entries that don't have a predefined prefix.
  final List<ChangelogEntry> others = <ChangelogEntry>[];

  /// Whether no [ChangelogEntry] exists.
  bool get empty =>
      additions.isEmpty && changes.isEmpty && fixes.isEmpty && removals.isEmpty;
}

/// Represents a single entry for a changelog.
///
/// Most entries consist of a single [line] but can have multiple additional
/// lines in [additionalInfo].
class ChangelogEntry {
  ChangelogEntry({
    @required this.line,
  });

  final String line;
  final List<String> additionalInfo = <String>[];
}

enum ChangelogType {
  addition,
  change,
  fix,
  removal,
  other,
}
