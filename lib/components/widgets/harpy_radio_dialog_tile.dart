import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';

class HarpyRadioDialogTile<T> extends ConsumerWidget {
  const HarpyRadioDialogTile({
    required this.groupValue,
    required this.entries,
    required this.onChanged,
    this.leading,
    this.title,
    this.borderRadius,
    this.dialogTitle,
  });

  final T groupValue;
  final Map<T, Widget> entries;

  final Widget? leading;
  final Widget? title;
  final BorderRadius? borderRadius;

  final Widget? dialogTitle;
  final ValueChanged<T>? onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(displayPreferencesProvider);

    return HarpyListTile(
      leading: leading,
      title: title,
      subtitle: entries[groupValue],
      multilineTitle: true,
      borderRadius: borderRadius,
      verticalAlignment: CrossAxisAlignment.center,
      onTap: () => showDialog<void>(
        context: context,
        builder: (_) => HarpyDialog(
          title: dialogTitle,
          contentPadding: display.edgeInsetsOnly(top: true),
          clipBehavior: Clip.antiAlias,
          content: Column(
            children: [
              for (final entry in entries.entries)
                HarpyRadioTile<T>(
                  title: entry.value,
                  value: entry.key,
                  groupValue: groupValue,
                  leadingPadding: display.edgeInsets / 2,
                  contentPadding: display.edgeInsets / 2,
                  onChanged: (value) {
                    HapticFeedback.lightImpact();
                    Navigator.of(context).pop();
                    if (value != groupValue) onChanged?.call(value);
                  },
                )
            ],
          ),
        ),
      ),
    );
  }
}
