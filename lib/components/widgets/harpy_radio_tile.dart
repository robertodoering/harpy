import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';

class HarpyRadioTile<T> extends ConsumerWidget {
  const HarpyRadioTile({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.title,
    this.subtitle,
    this.contentPadding,
    this.leadingPadding,
    this.trailingPadding,
  });

  final T value;
  final T? groupValue;
  final ValueChanged<T>? onChanged;

  final Widget? title;
  final Widget? subtitle;
  final EdgeInsets? contentPadding;
  final EdgeInsets? leadingPadding;
  final EdgeInsets? trailingPadding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final iconTheme = IconTheme.of(context);
    final display = ref.watch(displayPreferencesProvider);

    final radioPadding = display.paddingValue - (40 - iconTheme.size!) / 2;

    return HarpyListTile(
      leading: Radio<T>(
        value: value,
        groupValue: groupValue,
        onChanged: (value) {
          if (value != null) onChanged?.call(value);
        },
      ),
      title: title,
      subtitle: subtitle,
      onTap: onChanged != null ? () => onChanged?.call(value) : null,
      multilineTitle: true,
      contentPadding: contentPadding,
      leadingPadding: leadingPadding ??
          EdgeInsets.all(radioPadding.clamp(0, display.paddingValue)),
      trailingPadding: trailingPadding,
    );
  }
}
