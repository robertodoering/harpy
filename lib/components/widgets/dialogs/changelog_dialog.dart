import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';
import 'package:pedantic/pedantic.dart';

class ChangelogDialog extends StatelessWidget {
  const ChangelogDialog(this.data);

  final ChangelogData data;

  static Future<void> maybeShow(BuildContext context) async {
    final changelogPreferences = app<ChangelogPreferences>();

    if (changelogPreferences.shouldShowChangelogDialog) {
      final data = await app<ChangelogParser>().current(context);

      if (data != null) {
        unawaited(
          showDialog<void>(
            context: context,
            builder: (_) => ChangelogDialog(data),
          ),
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
      actions: [
        DialogAction<void>(
          text: 'ok',
          onTap: () => app<HarpyNavigator>().maybePop(),
        )
      ],
    );
  }
}
