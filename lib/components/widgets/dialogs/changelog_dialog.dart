import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';

class ChangelogDialog extends StatelessWidget {
  const ChangelogDialog(this.data);

  final ChangelogData data;

  static Future<void> maybeShow(BuildContext context) async {
    final ChangelogPreferences changelogPreferences =
        app<ChangelogPreferences>();

    if (changelogPreferences.shouldShowChangelogDialog) {
      final ChangelogData data = await app<ChangelogParser>().current(context);

      if (data != null) {
        showDialog<void>(
          context: context,
          builder: (_) => ChangelogDialog(data),
        );
      }
    }

    // always set to current shown version, even when the setting to show dialog
    // is false
    changelogPreferences.setToCurrentShownVersion();
  }

  @override
  Widget build(BuildContext context) {
    return HarpyDialog(
      title: const Text('whats new?'),
      contentPadding: const EdgeInsets.only(top: 24, left: 24, right: 24),
      content: ChangelogWidget(data),
      actions: <Widget>[
        DialogAction<void>(
          text: 'ok',
          onTap: () => app<HarpyNavigator>().state.maybePop(),
        )
      ],
    );
  }
}
