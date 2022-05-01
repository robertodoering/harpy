import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/rby/rby.dart';

class ChangelogDialog extends StatelessWidget {
  const ChangelogDialog({
    required this.data,
  });

  final ChangelogData data;

  static Future<void> maybeShow(BuildContext context, Reader read) async {
    final general = read(generalPreferencesProvider);
    final generalNotifier = read(generalPreferencesProvider.notifier);
    final deviceInfo = read(deviceInfoProvider);

    if (general.shouldShowChangelogDialog(deviceInfo)) {
      final data = await read(currentChangelogProvider.future).handleError();

      if (data != null) {
        showDialog<void>(
          context: context,
          builder: (_) => ChangelogDialog(data: data),
        ).ignore();
      }
    }

    // always set to current shown version
    generalNotifier.updateLastShownVersion();
  }

  @override
  Widget build(BuildContext context) {
    return HarpyDialog(
      title: const Text("what's new?"),
      content: ChangelogWidget(data: data),
      actions: [
        HarpyButton.text(
          label: const Text('ok'),
          onTap: Navigator.of(context).pop,
        ),
      ],
    );
  }
}
