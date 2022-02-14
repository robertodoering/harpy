import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';

class HarpyRadioTile<T> extends StatelessWidget {
  const HarpyRadioTile({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.title,
    this.contentPadding,
    this.leadingPadding,
    this.trailingPadding,
  });

  final T value;
  final T? groupValue;
  final ValueChanged<T>? onChanged;

  final Widget? title;
  final EdgeInsets? contentPadding;
  final EdgeInsets? leadingPadding;
  final EdgeInsets? trailingPadding;

  @override
  Widget build(BuildContext context) {
    return HarpyListTile(
      leading: Radio<T>(
        value: value,
        groupValue: groupValue,
        onChanged: (value) {
          if (value != null) onChanged?.call(value);
        },
      ),
      title: title,
      onTap: onChanged != null ? () => onChanged?.call(value) : null,
      multilineTitle: true,
      contentPadding: contentPadding,
      leadingPadding: leadingPadding,
      trailingPadding: trailingPadding,
    );
  }
}
