import 'package:flutter/material.dart';
import 'package:harpy/components/common/animations/implicit/animated_size.dart';
import 'package:harpy/components/common/dialogs/color_picker_dialog.dart';
import 'package:harpy/components/settings/custom_theme/bloc/custom_theme_bloc.dart';
import 'package:harpy/components/settings/custom_theme/bloc/custom_theme_event.dart';

/// Builds the accent color customization for the [CustomThemeScreen].
class AccentColorSelection extends StatelessWidget {
  const AccentColorSelection(this.bloc);

  final CustomThemeBloc bloc;

  Future<void> _changeAccentColor(BuildContext context, ThemeData theme) async {
    final Color newColor = await showDialog<Color>(
      context: context,
      builder: (BuildContext context) => ColorPickerDialog(
        color: theme.accentColor,
      ),
    );

    if (newColor != null) {
      bloc.add(ChangeAccentColor(color: newColor));
    }
  }

  Widget _buildColorWarning(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: const <Widget>[
          Icon(Icons.error_outline),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Accent color should provide more contrast on the background',
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return CustomAnimatedSize(
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text('Accent color', style: textTheme.headline4),
          ),
          const SizedBox(height: 8),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            color: theme.accentColor,
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              leading: const SizedBox(),
              trailing: const SizedBox(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              onTap: () => _changeAccentColor(context, theme),
            ),
          ),
          if (!bloc.accentColorContrasts) ...<Widget>[
            const SizedBox(height: 8),
            _buildColorWarning(theme),
          ],
        ],
      ),
    );
  }
}
