import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:rby/rby.dart';

// false positive
// ignore_for_file: avoid_redundant_argument_values

class ThemeCard extends ConsumerWidget {
  const ThemeCard(
    this.harpyTheme, {
    required this.selectedLightTheme,
    required this.selectedDarkTheme,
    required this.onTap,
    required this.onSelectLightTheme,
    required this.onSelectDarkTheme,
    this.onEdit,
    this.onDelete,
  });

  final HarpyTheme harpyTheme;
  final bool selectedLightTheme;
  final bool selectedDarkTheme;
  final VoidCallback onTap;
  final VoidCallback onSelectLightTheme;
  final VoidCallback onSelectDarkTheme;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  void _showBottomSheet(BuildContext context) {
    _showThemeSelectionBottomSheet(
      context,
      name: harpyTheme.name,
      selectedLightTheme: selectedLightTheme,
      selectedDarkTheme: selectedDarkTheme,
      onSelectLightTheme: onSelectLightTheme,
      onSelectDarkTheme: onSelectDarkTheme,
      onDelete: onDelete,
      onEdit: onEdit,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final brightness = ref.watch(platformBrightnessProvider);

    final style = harpyTheme.themeData.textTheme.titleSmall!;

    Color? borderColor;

    if (brightness == Brightness.light && selectedLightTheme ||
        brightness == Brightness.dark && selectedDarkTheme) {
      borderColor = harpyTheme.colors.primary;
    } else if (brightness == Brightness.light && selectedDarkTheme ||
        brightness == Brightness.dark && selectedLightTheme) {
      borderColor = harpyTheme.themeData.dividerColor;
    }

    return ClipRRect(
      borderRadius: theme.shape.borderRadius,
      child: _ThemeCardBase(
        harpyTheme: harpyTheme,
        borderColor: borderColor,
        onTap: onTap,
        onLongPress: () => _showBottomSheet(context),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: theme.spacing.edgeInsets,
                child: Text(
                  harpyTheme.name,
                  style: style,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            if (isPro) ...[
              // show an indicator for the selected light / dark theme in the
              // pro version
              if (selectedLightTheme)
                Padding(
                  padding: theme.spacing.edgeInsets,
                  child: Icon(
                    CupertinoIcons.sun_max,
                    color: brightness == Brightness.light
                        ? harpyTheme.colors.secondary
                        : harpyTheme.colors.onBackground.withOpacity(.5),
                  ),
                ),
              if (selectedDarkTheme)
                Padding(
                  padding: theme.spacing.edgeInsets,
                  child: Icon(
                    CupertinoIcons.moon,
                    color: brightness == Brightness.dark
                        ? harpyTheme.colors.secondary
                        : harpyTheme.colors.onBackground.withOpacity(.5),
                  ),
                ),
            ],
            RbyButton.transparent(
              icon: const Icon(CupertinoIcons.ellipsis_vertical),
              onTap: () => _showBottomSheet(context),
            ),
          ],
        ),
      ),
    );
  }
}

class LockedProThemeCard extends ConsumerWidget {
  const LockedProThemeCard(this.harpyTheme);

  final HarpyTheme harpyTheme;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final style = harpyTheme.themeData.textTheme.titleSmall!;

    return _ThemeCardBase(
      harpyTheme: harpyTheme,
      child: Padding(
        padding: theme.spacing.edgeInsets,
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Text(
                    harpyTheme.name,
                    style: style,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  HorizontalSpacer.small,
                  Container(
                    width: style.fontSize! - 2,
                    height: style.fontSize! - 2,
                    decoration: BoxDecoration(
                      color: harpyTheme.colors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  HorizontalSpacer.small,
                  Container(
                    width: style.fontSize! - 2,
                    height: style.fontSize! - 2,
                    decoration: BoxDecoration(
                      color: harpyTheme.colors.secondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
            const FlareIcon.shiningStar(),
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
    this.borderColor,
    this.onTap,
    this.onLongPress,
  });

  final HarpyTheme harpyTheme;
  final Color? borderColor;
  final Widget child;

  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final gradient = LinearGradient(
      colors: harpyTheme.colors.backgroundColors.length > 1
          ? harpyTheme.colors.backgroundColors.toList()
          : [
              harpyTheme.colors.backgroundColors.first,
              harpyTheme.colors.backgroundColors.first,
            ],
    );

    return Theme(
      data: harpyTheme.themeData,
      child: AnimatedContainer(
        duration: theme.animation.short,
        constraints: BoxConstraints(
          // prevent a height difference when icons in the card show
          // min height: icon size + 2 (border) + vertical padding
          minHeight:
              harpyTheme.themeData.iconTheme.size! + 2 + theme.spacing.base * 2,
        ),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: theme.shape.borderRadius,
          border: Border.all(color: borderColor ?? Colors.transparent),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: theme.shape.borderRadius,
            onTap: onTap,
            onLongPress: onLongPress,
            child: child,
          ),
        ),
      ),
    );
  }
}

void _showThemeSelectionBottomSheet(
  BuildContext context, {
  required String name,
  required bool selectedLightTheme,
  required bool selectedDarkTheme,
  required VoidCallback onSelectLightTheme,
  required VoidCallback onSelectDarkTheme,
  required VoidCallback? onDelete,
  required VoidCallback? onEdit,
}) {
  final theme = Theme.of(context);

  showRbyBottomSheet<void>(
    context,
    children: [
      BottomSheetHeader(
        child: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      if (onDelete != null)
        RbyListTile(
          leading: Icon(CupertinoIcons.delete, color: theme.colorScheme.error),
          title: Text(
            'delete',
            style: TextStyle(
              color: theme.colorScheme.error,
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
        RbyListTile(
          leading: const Icon(FeatherIcons.edit2),
          title: const Text('edit'),
          onTap: () {
            HapticFeedback.lightImpact();
            Navigator.of(context).pop();
            onEdit();
          },
        ),
      RbyListTile(
        leading: Icon(
          CupertinoIcons.sun_max,
          color: isPro && selectedLightTheme ? theme.colorScheme.primary : null,
        ),
        title: isPro && selectedLightTheme
            ? Text(
                'used as system light theme',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              )
            : const Text('use as system light theme'),
        subtitle: isFree ? const Text('only available in harpy pro') : null,
        trailing: isFree ? const FlareIcon.shiningStar() : null,
        enabled: isPro,
        onTap: () {
          HapticFeedback.lightImpact();
          Navigator.of(context).pop();
          onSelectLightTheme();
        },
      ),
      RbyListTile(
        leading: Icon(
          CupertinoIcons.moon,
          color: isPro && selectedDarkTheme ? theme.colorScheme.primary : null,
        ),
        title: isPro && selectedDarkTheme
            ? Text(
                'used as system dark theme',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              )
            : const Text('use as system dark theme'),
        subtitle: isFree ? const Text('only available in harpy pro') : null,
        trailing: isFree ? const FlareIcon.shiningStar() : null,
        enabled: isPro,
        onTap: () {
          HapticFeedback.lightImpact();
          Navigator.of(context).pop();
          onSelectDarkTheme();
        },
      ),
    ],
  );
}
