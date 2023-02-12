import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:rby/rby.dart';

class ChangelogDialog extends StatelessWidget {
  const ChangelogDialog({
    required this.data,
  });

  final ChangelogData data;

  static Future<void> maybeShow(WidgetRef ref) async {
    final general = ref.read(generalPreferencesProvider);
    final generalNotifier = ref.read(generalPreferencesProvider.notifier);
    final deviceInfo = ref.read(deviceInfoProvider);

    if (general.shouldShowChangelogDialog(deviceInfo)) {
      final data =
          await ref.read(currentChangelogProvider.future).handleError();

      if (data != null) {
        // ignore: use_build_context_synchronously
        showDialog<void>(
          context: ref.context,
          builder: (_) => ChangelogDialog(data: data),
        ).ignore();
      }
    }

    // always set to current shown version
    SchedulerBinding.instance.addPostFrameCallback((_) {
      generalNotifier.updateLastShownVersion();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RbyDialog(
      title: const Text("what's new?"),
      content: ChangelogWidget(data: data),
      actions: [
        RbyButton.text(
          label: const Text('ok'),
          onTap: Navigator.of(context).pop,
        ),
      ],
    );
  }
}
