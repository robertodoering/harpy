import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

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
      padding: DefaultEdgeInsets.symmetric(horizontal: true),
      child: Row(
        children: <Widget>[
          const Icon(Icons.error_outline),
          defaultHorizontalSpacer,
          const Expanded(
            child: Text(
              'accent color should provide more contrast on the background',
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
            padding: DefaultEdgeInsets.symmetric(horizontal: true),
            child: Text('accent color', style: textTheme.headline4),
          ),
          defaultVerticalSpacer,
          Card(
            margin: DefaultEdgeInsets.symmetric(horizontal: true),
            color: theme.accentColor,
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              leading: const SizedBox(),
              trailing: const SizedBox(),
              shape: kDefaultShapeBorder,
              onTap: () => _changeAccentColor(context, theme),
            ),
          ),
          if (!bloc.accentColorContrasts) ...<Widget>[
            defaultVerticalSpacer,
            _buildColorWarning(theme),
          ],
        ],
      ),
    );
  }
}
