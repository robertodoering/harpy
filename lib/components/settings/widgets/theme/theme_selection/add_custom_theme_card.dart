import 'package:flutter/material.dart';
import 'package:harpy/components/common/misc/flare_icons.dart';
import 'package:harpy/core/message_service.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/harpy.dart';

/// A card used to add a custom theme for the [ThemeSelectionScreen].
class AddCustomThemeCard extends StatelessWidget {
  const AddCustomThemeCard();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    // only build a trailing icon when using harpy free
    final Widget trailing = Harpy.isFree
        ? const FlareIcon.shiningStar(
            size: 28,
          )
        : null;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: theme.dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: ListTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          leading: const Icon(Icons.add),
          title: const Text('Add custom theme'),
          trailing: trailing,
          onTap: () {
            // todo: navigate to custom theme screen
            app<MessageService>().showInfo('Not yet available');
          },
        ),
      ),
    );
  }
}
