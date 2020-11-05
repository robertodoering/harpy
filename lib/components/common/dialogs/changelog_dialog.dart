import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:harpy/components/common/dialogs/harpy_dialog.dart';
import 'package:harpy/core/harpy_info.dart';
import 'package:harpy/core/preferences/changelog_preferences.dart';
import 'package:harpy/core/service_locator.dart';

class ChangelogDialog extends StatefulWidget {
  const ChangelogDialog();

  static Future<void> show(BuildContext context) async {
    final ChangelogPreferences changelogPreferences =
        app<ChangelogPreferences>();
    final HarpyInfo harpyInfo = app<HarpyInfo>();

    // set last shown version to current version when
    changelogPreferences.lastShownVersion =
        int.tryParse(harpyInfo.packageInfo.buildNumber) ?? 0;

    await Future<void>.delayed(Duration.zero);

    showDialog<void>(
      context: context,
      child: const ChangelogDialog(),
    );
  }

  @override
  _ChangelogDialogState createState() => _ChangelogDialogState();
}

class _ChangelogDialogState extends State<ChangelogDialog> {
  String _text = '';

  @override
  void initState() {
    super.initState();

    rootBundle
        .loadString(
          'android/fastlane/metadata/android/en-US/changelogs/17.txt',
          cache: false,
        )
        .then(
          (String value) => setState(() {
            _text = value;
          }),
        );
  }

  @override
  Widget build(BuildContext context) {
    return HarpyDialog(
      title: const Text('Whats new?'),
      content: Text(_text),
    );
  }
}
