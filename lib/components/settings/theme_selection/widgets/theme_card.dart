import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    required this.onTap,
    required this.onSelectLightTheme,
    required this.onSelectDarkTheme,
    this.enableBottomSheet = false,
    this.onEdit,
    this.onDelete,
  });

  final HarpyTheme harpyTheme;
  final bool selectedLightTheme;
  final bool selectedDarkTheme;
  final VoidCallback onTap;
  final VoidCallback onSelectLightTheme;
  final VoidCallback onSelectDarkTheme;
  final bool enableBottomSheet;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  void _showBottomSheet(BuildContext context) {
    showThemeSelectionBottomSheet(
      context,
      name: harpyTheme.name,
      onSelectLightTheme: onSelectLightTheme,
      onSelectDarkTheme: onSelectDarkTheme,
      onDelete: onDelete,
      onEdit: onEdit,
    );
  }

  @override
  Widget build(BuildContext context) {
    final systemBrightness = context.watch<Brightness>();
    final config = context.watch<ConfigCubit>().state;

    return _ThemeCardBase(
      harpyTheme: harpyTheme,
      selected: selectedLightTheme || selectedDarkTheme,
      child: InkWell(
        onTap: onTap,
        onLongPress: enableBottomSheet ? () => _showBottomSheet(context) : null,
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
            if (Harpy.isPro) ...[
              // show an indicator for the selected light / dark theme in the
              // pro version
              if (selectedLightTheme)
                Padding(
                  padding: config.edgeInsets,
                  child: Icon(
                    CupertinoIcons.sun_max,
                    color: systemBrightness == Brightness.light
                        ? harpyTheme.secondaryColor
                        : null,
                  ),
                ),
              if (selectedDarkTheme)
                Padding(
                  padding: config.edgeInsets,
                  child: Icon(
                    CupertinoIcons.moon,
                    color: systemBrightness == Brightness.dark
                        ? harpyTheme.secondaryColor
                        : null,
                  ),
                ),
            ],
            if (enableBottomSheet)
              HarpyButton.flat(
                padding: config.edgeInsets,
                icon: const Icon(CupertinoIcons.ellipsis_vertical),
                onTap: () => _showBottomSheet(context),
              ),
          ],
        ),
      ),
    );
  }
}

class ProThemeCard extends StatelessWidget {
  const ProThemeCard(this.harpyTheme);

  final HarpyTheme harpyTheme;

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigCubit>().state;

    return _ThemeCardBase(
      harpyTheme: harpyTheme,
      selected: false,
      child: Padding(
        padding: config.edgeInsets,
        child: Row(
          children: [
            Expanded(
              child: Text(
                harpyTheme.name,
                style: harpyTheme.themeData.textTheme.subtitle2,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const FlareIcon.shiningStar(size: 22),
          ],
        ),
      ),
    );
  }
}

class _ThemeCardBase extends StatelessWidget {
  const _ThemeCardBase({
    required this.harpyTheme,
    required this.selected,
    required this.child,
  });

  final HarpyTheme harpyTheme;
  final bool selected;
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
          border: selected
              ? Border.all(color: harpyTheme.primaryColor)
              : Border.all(color: Colors.transparent),
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
  required VoidCallback onSelectLightTheme,
  required VoidCallback onSelectDarkTheme,
  required VoidCallback? onDelete,
  required VoidCallback? onEdit,
}) {
  final theme = Theme.of(context);

  showHarpyBottomSheet<void>(
    context,
    children: [
      BottomSheetHeader(
        child: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      if (onDelete != null)
        HarpyListTile(
          leading: Icon(CupertinoIcons.delete, color: theme.errorColor),
          title: Text(
            'delete',
            style: TextStyle(
              color: theme.errorColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () {
            HapticFeedback.lightImpact();
            Navigator.of(context).pop();
            onDelete();
          },
        ),
      if (onEdit != null)
        HarpyListTile(
          leading: const Icon(FeatherIcons.edit2),
          title: const Text('edit'),
          onTap: () {
            HapticFeedback.lightImpact();
            Navigator.of(context).pop();
            onEdit();
          },
        ),
      HarpyListTile(
        leading: const Icon(CupertinoIcons.sun_max),
        title: const Text('use as system light theme'),
        subtitle:
            Harpy.isFree ? const Text('only available in harpy pro') : null,
        trailing: Harpy.isFree ? const FlareIcon.shiningStar(size: 24) : null,
        // false positive
        // ignore: avoid_redundant_argument_values
        onTap: Harpy.isFree
            ? null
            : () {
                HapticFeedback.lightImpact();
                Navigator.of(context).pop();
                onSelectLightTheme();
              },
      ),
      HarpyListTile(
        leading: const Icon(CupertinoIcons.moon),
        title: const Text('use as system dark theme'),
        subtitle:
            Harpy.isFree ? const Text('only available in harpy pro') : null,
        trailing: Harpy.isFree ? const FlareIcon.shiningStar(size: 24) : null,
        // false positive
        // ignore: avoid_redundant_argument_values
        onTap: Harpy.isFree
            ? null
            : () {
                HapticFeedback.lightImpact();
                Navigator.of(context).pop();
                onSelectDarkTheme();
              },
      ),
    ],
  );
}
