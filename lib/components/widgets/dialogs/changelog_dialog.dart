import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/misc/misc.dart';

class ChangelogDialog extends StatefulWidget {
  const ChangelogDialog();

  static Future<void> maybeShow(BuildContext context) async {
    final ChangelogPreferences changelogPreferences =
        app<ChangelogPreferences>();

    if (changelogPreferences.shouldShowChangelogDialog) {
      await Future<void>.delayed(Duration.zero);

      showDialog<void>(
        context: context,
        builder: (_) => const ChangelogDialog(),
      );
    }

    // always set to current shown version, even when the setting to show dialog
    // is false
    changelogPreferences.setToCurrentShownVersion();
  }

  @override
  _ChangelogDialogState createState() => _ChangelogDialogState();
}

class _ChangelogDialogState extends State<ChangelogDialog> {
  final ChangelogPreferences changelogPreferences = app<ChangelogPreferences>();

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
          return const Text('no changelog found');
        }
      },
    );
  }

  Widget _buildCheckbox() {
    return CheckboxListTile(
      value: !changelogPreferences.showChangelogDialog,
      title: Text(
        "don't show this again",
        style: Theme.of(context).textTheme.subtitle2,
      ),
      onChanged: (bool value) {
        setState(() => changelogPreferences.showChangelogDialog = !value);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return HarpyDialog(
      title: const Text('whats new?'),
      contentPadding: const EdgeInsets.only(top: 24, left: 24, right: 24),
      content: Column(
        children: <Widget>[
          _buildChangelogWidget(),
          const SizedBox(height: 24),
          _buildCheckbox(),
        ],
      ),
      actions: <Widget>[
        DialogAction<void>(
          text: 'ok',
          onTap: () => app<HarpyNavigator>().state.maybePop(),
        )
      ],
    );
  }
}
