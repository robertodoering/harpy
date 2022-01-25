import 'package:flutter/material.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

class HarpySwitchTile extends StatelessWidget {
  const HarpySwitchTile({
    required this.value,
    this.title,
    this.subtitle,
    this.leading,
    this.borderRadius,
    this.onChanged,
    this.enabled = true,
  });

  final bool value;

  final Widget? title;
  final Widget? subtitle;
  final Widget? leading;
  final BorderRadius? borderRadius;

  final ValueChanged<bool>? onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return HarpyListTile(
      title: title,
      subtitle: subtitle,
      leading: leading,
      trailingPadding: EdgeInsets.zero,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
      borderRadius: borderRadius,
      verticalAlignment: CrossAxisAlignment.center,
      enabled: enabled,
      multilineTitle: true,
      onTap: onChanged != null ? () => onChanged!(!value) : null,
    );
  }
}
