import 'package:flutter/material.dart';
import 'package:harpy/components/common/animations/implicit/animated_size.dart';
import 'package:harpy/components/settings/custom_theme/bloc/custom_theme_bloc.dart';
import 'package:harpy/components/settings/custom_theme/bloc/custom_theme_event.dart';

/// Builds the theme name customization for the [CustomThemeScreen].
class ThemeNameSelection extends StatefulWidget {
  const ThemeNameSelection(this.bloc);

  final CustomThemeBloc bloc;

  @override
  _ThemeNameSelectionState createState() => _ThemeNameSelectionState();
}

class _ThemeNameSelectionState extends State<ThemeNameSelection> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: widget.bloc.harpyTheme.name)
      ..addListener(() => widget.bloc.add(RenameTheme(name: _controller.text)));
  }

  Widget _buildInvalidName(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.error_outline,
            color: theme.errorColor,
          ),
          const SizedBox(width: 8),
          Text(
            'Invalid name',
            style: TextStyle(color: theme.errorColor),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return CustomAnimatedSize(
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TextField(
              controller: _controller,
              maxLength: 20,
            ),
          ),
          if (!widget.bloc.validName) ...<Widget>[
            const SizedBox(height: 8),
            _buildInvalidName(theme),
          ],
        ],
      ),
    );
  }
}
