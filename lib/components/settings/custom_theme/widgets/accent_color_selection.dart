import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:provider/provider.dart';

/// Builds the accent color customization for the [CustomThemeScreen].
class AccentColorSelection extends StatelessWidget {
  const AccentColorSelection(this.bloc);

  final CustomThemeBloc bloc;

  Future<void> _changeAccentColor(BuildContext context, ThemeData theme) async {
    final newColor = await showDialog<Color>(
      context: context,
      builder: (_) => ColorPickerDialog(
        color: theme.accentColor,
      ),
    );

    if (newColor != null) {
      bloc.add(ChangeAccentColor(color: newColor));
    }
  }

  Widget _buildColorWarning(ConfigState config, ThemeData theme) {
    return Padding(
      padding: config.edgeInsetsSymmetric(horizontal: true),
      child: Row(
        children: const [
          Icon(Icons.error_outline),
          defaultHorizontalSpacer,
          Expanded(
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
    final theme = Theme.of(context);
    final config = context.watch<ConfigBloc>().state;
    final textTheme = theme.textTheme;

    return CustomAnimatedSize(
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: config.edgeInsetsSymmetric(horizontal: true),
            child: Text('accent color', style: textTheme.headline4),
          ),
          defaultVerticalSpacer,
          Card(
            margin: config.edgeInsetsSymmetric(horizontal: true),
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
            _buildColorWarning(config, theme),
          ],
        ],
      ),
    );
  }
}
