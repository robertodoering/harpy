import 'package:flutter/material.dart';
import 'package:harpy/components/common/animations/implicit/animated_size.dart';
import 'package:harpy/components/settings/custom_theme/bloc/custom_theme_bloc.dart';
import 'package:harpy/components/settings/custom_theme/bloc/custom_theme_event.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';

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
      padding: DefaultEdgeInsets.symmetric(horizontal: true),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.error_outline,
            color: theme.errorColor,
          ),
          defaultHorizontalSpacer,
          Text(
            'invalid name',
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
            padding: DefaultEdgeInsets.symmetric(horizontal: true),
            child: TextField(
              controller: _controller,
              maxLength: 20,
            ),
          ),
          if (!widget.bloc.validName) ...<Widget>[
            defaultSmallVerticalSpacer,
            _buildInvalidName(theme),
          ],
        ],
      ),
    );
  }
}
