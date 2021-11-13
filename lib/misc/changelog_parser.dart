import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy.dart';
import 'package:intl/intl.dart';

const _linePrefix = '· ';

/// Parses the [ChangelogData] from a changelog file located in
/// `android/fastlane/metadata/android/$flavor/en-US/changelogs/$versionCode.txt`.
class ChangelogParser with HarpyLogger {
  const ChangelogParser();

  /// Returns the [ChangelogData] for the current version.
  ///
  /// Returns `null` if the current version has no changelog file.
  Future<ChangelogData?> current(BuildContext? context) async {
    return parse(context, app<HarpyInfo>().packageInfo!.buildNumber);
  }

  /// Returns the [ChangelogData] for the [versionCode].
  ///
  /// Returns `null` if no corresponding changelog file exists.
  Future<ChangelogData?> parse(
    BuildContext? context,
    String versionCode,
  ) async {
    try {
      final changelogString = await rootBundle.loadString(
        _changelogString(versionCode),
        cache: false,
      );

      final data = ChangelogData(versionCode: versionCode);

      ChangelogEntry? entry;

      var entryStart = changelogString.indexOf(_linePrefix);
      if (entryStart == -1) {
        entryStart = 0;
      }

      final headerString = changelogString.substring(0, entryStart);
      final headerLines = _cleanEmptyLines(
        headerString.split('\n'),
      );

      for (var i = 0; i < headerLines.length; i++) {
        final line = headerLines[i].trim();

        if (dateRegex.hasMatch(line)) {
          // localize date format
          data.headerLines.add(
            DateFormat.yMMMd(Localizations.localeOf(context!).languageCode)
                .format(DateTime.parse(line)),
          );
        } else if (line.isNotEmpty || i != 0 || i != headerLines.length - 1) {
          // only add empty lines if they are not the first or last line
          data.headerLines.add(line);
        }
      }

      final entryString = changelogString.substring(entryStart);

      for (var line in entryString.split('\n')) {
        line = line.replaceFirst(_linePrefix, '');

        if (line.trim().isEmpty) {
          continue;
        }

        if (line.startsWith(' ') && entry != null) {
          // additional information for the last line
          entry.additionalInfo.add(line.trim());
        } else if (line.startsWith('Added') || line.startsWith('Improved')) {
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
    } on FlutterError {
      // ignore asset not found exception (version has no changelog)
      return null;
    } catch (e, st) {
      log.severe('error parsing changelog data', e, st);
      return null;
    }
  }

  String _changelogString(String versionCode) {
    const flavor = isFree ? 'free' : 'pro';

    return 'android/fastlane/metadata/android'
        '/$flavor/en-US/changelogs/$versionCode.txt';
  }

  ChangelogEntry _parseLine(String line) {
    return ChangelogEntry(line: line.trim());
  }

  List<String> _cleanEmptyLines(List<String> lines) {
    lines = _trimLeadingLines(lines);
    lines = _trimLeadingLines(lines.reversed.toList());
    return lines.reversed.toList();
  }

  List<String> _trimLeadingLines(List<String> lines) {
    final cleaned = <String>[];

    var ignore = true;
    for (final line in lines) {
      if (ignore && line.trim().isEmpty) {
        continue;
      }

      ignore = false;

      cleaned.add(line.trim());
    }

    return cleaned;
  }
}

/// Represents the data of a changelog for one version.
class ChangelogData {
  ChangelogData({
    this.versionCode,
  });

  final String? versionCode;

  /// Optional information at the beginning of the changelog, including the
  /// name of the version ('Version x.y.z').
  final List<String> headerLines = [];

  /// Entries that start with 'Added'.
  final List<ChangelogEntry> additions = [];

  /// Entries that start with 'Changed'.
  final List<ChangelogEntry> changes = [];

  /// Entries that start with 'Fixed'.
  final List<ChangelogEntry> fixes = [];

  /// Entries that start with 'Removed'.
  final List<ChangelogEntry> removals = [];

  /// Entries that don't have a predefined prefix.
  final List<ChangelogEntry> others = [];

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
    required this.line,
  });

  final String line;
  final List<String> additionalInfo = [];
}

enum ChangelogType {
  addition,
  change,
  fix,
  removal,
  other,
}
