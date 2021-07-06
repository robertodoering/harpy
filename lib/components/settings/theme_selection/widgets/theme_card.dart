import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

/// A card representing a selectable [HarpyTheme] for the
/// [ThemeSelectionScreen].
class ThemeCard extends StatelessWidget {
  const ThemeCard(
    this.harpyTheme, {
    this.selected = false,
    this.canEdit = false,
    this.onTap,
    this.onEdit,
  });

  final HarpyTheme harpyTheme;
  final bool selected;
  final bool canEdit;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;

  LinearGradient get gradient => LinearGradient(
        colors: harpyTheme.backgroundColors.length > 1
            ? harpyTheme.backgroundColors
            : <Color>[
                harpyTheme.backgroundColors.first,
                harpyTheme.backgroundColors.first
              ],
      );

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: harpyTheme.themeData,
      child: Card(
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              decoration: BoxDecoration(gradient: gradient),
              child: Material(
                type: MaterialType.transparency,
                child: ListTile(
                  title: Text(harpyTheme.name),
                  leading: canEdit ? const SizedBox() : null,
                  trailing: selected ? const Icon(FeatherIcons.check) : null,
                  onTap: onTap,
                ),
              ),
            ),
            if (canEdit)
              HarpyButton.flat(
                icon: const Icon(FeatherIcons.edit2),
                padding: const EdgeInsets.all(16),
                onTap: onEdit,
              ),
          ],
        ),
      ),
    );
  }
}
