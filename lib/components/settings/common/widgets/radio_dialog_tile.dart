import 'package:flutter/material.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';

/// Builds a [ListTile] that opens a [HarpyDialog] and displays the [items] as
/// [RadioListTile]s.
class RadioDialogTile extends StatelessWidget {
  const RadioDialogTile({
    @required this.title,
    @required this.leading,
    @required this.value,
    @required this.items,
    @required this.description,
    @required this.onChanged,
    this.enabled = true,
  });

  /// The title for this setting used as the [ListTile.title].
  final String title;

  /// The [IconData] for the [ListTile.leading] icon.
  final IconData leading;

  /// The value of the current settings.
  final int value;

  /// The list of items that appear as [RadioListTile]s.
  final List<String> items;

  /// The text used as the title for the dialog.
  final String description;

  /// The callback when a new selection has been made.
  final ValueChanged<int> onChanged;

  /// Whether this [ListTile] is enabled.
  final bool enabled;

  Widget _buildDialog() {
    return HarpyDialog(
      animationType: DialogAnimationType.slide,
      title: Text(description),
      content: Column(
        children: <Widget>[
          for (int i = 0; i < items.length; i++)
            RadioListTile<int>(
              value: i,
              groupValue: value,
              title: Text(items[i]),
              onChanged: (int value) async {
                await app<HarpyNavigator>().state.maybePop();
                onChanged?.call(value);
              },
            )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(leading),
      title: Text(title),
      subtitle: Text(items[value]),
      onTap: () {
        showDialog<int>(
          context: context,
          builder: (BuildContext context) => _buildDialog(),
        );
      },
      enabled: enabled,
    );
  }
}
