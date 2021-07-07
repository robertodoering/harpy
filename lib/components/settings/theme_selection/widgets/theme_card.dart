import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:provider/provider.dart';

/// A card representing a selectable [HarpyTheme] for the
/// [ThemeSelectionScreen].
class ThemeCard extends StatelessWidget {
  const ThemeCard(
    this.harpyTheme, {
    required this.selectedLightTheme,
    required this.selectedDarkTheme,
    this.deletable = false,
    this.editable = false,
    this.onTap,
    this.onEdit,
  });

  final HarpyTheme harpyTheme;
  final bool selectedLightTheme;
  final bool selectedDarkTheme;
  final bool deletable;
  final bool editable;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigBloc>().state;

    return _ThemeCardBase(
      harpyTheme: harpyTheme,
      child: InkWell(
        onTap: onTap,
        onLongPress: () => showThemeSelectionBottomSheet(
          context,
          name: harpyTheme.name,
          deletable: deletable,
          editable: editable,
        ),
        borderRadius: kDefaultBorderRadius,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: config.edgeInsets,
                child: Text(
                  harpyTheme.name,
                  style: harpyTheme.themeData.textTheme.subtitle2,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            if (selectedLightTheme)
              Padding(
                padding: config.edgeInsets,
                child: const Icon(CupertinoIcons.sun_max),
              ),
            if (selectedDarkTheme)
              Padding(
                padding: config.edgeInsets,
                child: const Icon(CupertinoIcons.moon),
              ),
            HarpyButton.flat(
              padding: config.edgeInsets,
              icon: const Icon(CupertinoIcons.ellipsis_vertical),
              onTap: () => showThemeSelectionBottomSheet(
                context,
                name: harpyTheme.name,
                deletable: deletable,
                editable: editable,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeCardBase extends StatelessWidget {
  const _ThemeCardBase({
    required this.harpyTheme,
    required this.child,
  });

  final HarpyTheme harpyTheme;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final gradient = LinearGradient(
      colors: harpyTheme.backgroundColors.length > 1
          ? harpyTheme.backgroundColors
          : [
              harpyTheme.backgroundColors.first,
              harpyTheme.backgroundColors.first
            ],
    );

    return Theme(
      data: harpyTheme.themeData,
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: kDefaultBorderRadius,
        ),
        child: Material(
          type: MaterialType.transparency,
          child: child,
        ),
      ),
    );
  }
}

void showThemeSelectionBottomSheet(
  BuildContext context, {
  required String name,
  required bool deletable,
  required bool editable,
}) {
  final theme = Theme.of(context);

  showHarpyBottomSheet<void>(
    context,
    children: [
      BottomSheetHeader(
        child: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      if (deletable)
        ListTile(
          leading: Icon(CupertinoIcons.delete, color: theme.errorColor),
          title: Text(
            'delete',
            style: TextStyle(
              color: theme.errorColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () {},
        ),
      if (editable)
        ListTile(
          leading: const Icon(FeatherIcons.edit2),
          title: const Text('edit'),
          onTap: () {}, // todo
        ),
      ListTile(
        leading: const Icon(CupertinoIcons.sun_max),
        title: const Text('use as system light theme'),
        subtitle:
            Harpy.isFree ? const Text('only available in harpy pro') : null,
        trailing: Harpy.isFree ? const FlareIcon.shiningStar(size: 24) : null,
        // false positive linter warning
        // ignore: avoid_redundant_argument_values
        onTap: Harpy.isFree ? null : () {},
      ),
      ListTile(
        leading: const Icon(CupertinoIcons.moon),
        title: const Text('use as system dark theme'),
        subtitle:
            Harpy.isFree ? const Text('only available in harpy pro') : null,
        trailing: Harpy.isFree ? const FlareIcon.shiningStar(size: 24) : null,
        // false positive linter warning
        // ignore: avoid_redundant_argument_values
        onTap: Harpy.isFree ? null : () {},
      ),
    ],
  );
}
