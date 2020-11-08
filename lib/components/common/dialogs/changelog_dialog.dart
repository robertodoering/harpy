import 'package:flutter/material.dart';
import 'package:harpy/components/changelog/widgets/changelog_widget.dart';
import 'package:harpy/components/common/dialogs/harpy_dialog.dart';
import 'package:harpy/core/harpy_info.dart';
import 'package:harpy/core/preferences/changelog_preferences.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/misc/changelog_parser.dart';
import 'package:harpy/misc/harpy_navigator.dart';

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
  Future<ChangelogData> _data;

  @override
  void initState() {
    super.initState();

    _data = app<ChangelogParser>().current();
  }

  Widget _buildChangelogWidget() {
    return FutureBuilder<ChangelogData>(
      future: _data,
      builder: (BuildContext context, AsyncSnapshot<ChangelogData> snapshot) {
        if (snapshot.hasData) {
          return ChangelogWidget(snapshot.data);
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          return const Text('No changelog found');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return HarpyDialog(
      title: const Text('Whats new?'),
      contentPadding: const EdgeInsets.only(top: 24, left: 24, right: 24),
      content: Column(
        children: <Widget>[
          _buildChangelogWidget(),
          const SizedBox(height: 24),
          CheckboxListTile(
            value: false,
            title: Text(
              "Don't show this again",
              style: Theme.of(context).textTheme.subtitle2,
            ),
            onChanged: (bool value) {
              // todo: implement
            },
          ),
        ],
      ),
      actions: <Widget>[
        DialogAction<void>(
          text: 'Ok',
          onTap: () => app<HarpyNavigator>().state.maybePop(),
        )
      ],
    );
  }
}
