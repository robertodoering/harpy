import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';
import 'package:pedantic/pedantic.dart';

/// Builds a [ListTile] that opens a [HarpyDialog] and displays entries in
/// the dialog content as [RadioListTile]s.
class RadioDialogTile<T> extends StatelessWidget {
  const RadioDialogTile({
    required this.value,
    required this.leading,
    required this.title,
    required this.description,
    required this.titles,
    required this.values,
    required this.onChanged,
    this.trailing,
    this.trailingPadding,
    this.subtitle,
    this.subtitles,
    this.enabled = true,
    this.denseRadioTiles = false,
    this.popOnOpen = false,
    this.borderRadius,
  })  : assert(titles.length == values.length),
        assert(subtitles == null || subtitles.length == titles.length);

  /// The current value of this setting.
  final T value;

  /// The leading widget of this setting for the [ListTile].
  final IconData leading;

  /// The title of the this setting for the [ListTile].
  final String title;

  /// The subtitle of this setting for the [ListTile].
  final String? subtitle;

  /// The description for the dialog that shows the radio list tile entries.
  final String description;

  /// The titles for the radio list tile entries.
  final List<String> titles;

  /// The subtitles for the radio list tile entries.
  final List<String>? subtitles;

  /// The values for the radio list tile entries.
  final List<T> values;

  final ValueChanged<T?>? onChanged;
  final bool enabled;
  final bool denseRadioTiles;
  final Widget? trailing;
  final EdgeInsets? trailingPadding;
  final bool popOnOpen;
  final BorderRadius? borderRadius;

  Widget _buildDialog(BuildContext context) {
    return HarpyDialog(
      animationType: DialogAnimationType.slide,
      title: Text(description),
      contentPadding: const EdgeInsets.symmetric(vertical: 24),
      actions: [
        DialogAction<void>(
          text: 'back',
          onTap: Navigator.of(context).pop,
        ),
      ],
      content: Column(
        children: [
          for (int i = 0; i < values.length; i++)
            RadioListTile<T>(
              value: values[i],
              contentPadding: const EdgeInsets.symmetric(horizontal: 24),
              groupValue: value,
              title: Text(titles[i]),
              subtitle: subtitles != null ? Text(subtitles![i]) : null,
              dense: denseRadioTiles,
              onChanged: (value) async {
                unawaited(HapticFeedback.lightImpact());
                await app<HarpyNavigator>().maybePop();
                onChanged?.call(value);
              },
            )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return HarpyListTile(
      leading: Icon(leading),
      title: Text(title),
      multilineTitle: true,
      subtitle: subtitle != null ? Text(subtitle!) : null,
      enabled: enabled,
      trailing: trailing,
      trailingPadding: trailingPadding,
      borderRadius: borderRadius,
      onTap: () {
        if (popOnOpen) {
          Navigator.of(context).pop();
        }
        showDialog<int>(
          context: context,
          builder: _buildDialog,
        );
      },
    );
  }
}
