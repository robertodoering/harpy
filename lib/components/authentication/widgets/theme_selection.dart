import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:harpy/components/application/bloc/application_bloc.dart';
import 'package:harpy/components/application/bloc/application_event.dart';
import 'package:harpy/components/common/animations/animation_constants.dart';
import 'package:harpy/components/common/animations/explicit/fade_animation.dart';
import 'package:harpy/core/theme/harpy_theme.dart';
import 'package:harpy/core/theme/predefined_themes.dart';

/// A theme selection carousel used in the [SetupScreen].
///
/// The carousel contains the [predefinedThemes] and changes the selected
/// [HarpyTheme].
class ThemeSelection extends StatefulWidget {
  const ThemeSelection();

  @override
  _ThemeSelectionState createState() => _ThemeSelectionState();
}

class _ThemeSelectionState extends State<ThemeSelection> {
  List<HarpyTheme> get _themes => predefinedThemes;

  PageController _controller;

  int _currentPage = 0;

  bool get _canPrevious => _currentPage > 0;
  bool get _canNext => _currentPage < _themes.length - 1;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: .3)
      ..addListener(() {
        setState(() {
          _currentPage = _controller.page.round();
        });
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  List<Widget> _buildItems() {
    return <Widget>[
      for (HarpyTheme harpyTheme in predefinedThemes)
        Container(
          margin: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            border: Border.all(
              color: harpyTheme.backgroundComplimentaryColor,
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: harpyTheme.backgroundColors.length == 1
                  ? <Color>[
                      harpyTheme.backgroundColors.first,
                      harpyTheme.backgroundColors.first,
                    ]
                  : harpyTheme.backgroundColors,
            ),
            shape: BoxShape.circle,
          ),
        ),
    ];
  }

  void _previous() {
    if (_canPrevious) {
      _controller.previousPage(
        duration: kShortAnimationDuration,
        curve: Curves.easeOutCubic,
      );
      _onSelectionChange(_currentPage - 1);
    }
  }

  void _next() {
    if (_canNext) {
      _controller.nextPage(
        duration: kShortAnimationDuration,
        curve: Curves.easeOutCubic,
      );

      _onSelectionChange(_currentPage + 1);
    }
  }

  void _onSelectionChange(int index) {
    // todo: cleanup
    ApplicationBloc.of(context).add(
      ChangeThemeEvent(harpyTheme: _themes[index], id: index),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color iconColor = IconTheme.of(context).color;
    final Color leftIconColor = iconColor.withOpacity(_canPrevious ? 0.8 : 0.2);
    final Color rightIconColor = iconColor.withOpacity(_canNext ? 0.8 : 0.2);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        FadeAnimation(
          duration: kShortAnimationDuration,
          child: Text(
            _themes[_currentPage].name,
            style: theme.textTheme.subtitle2.copyWith(
              fontStyle: FontStyle.italic,
              letterSpacing: 2,
            ),
          ),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 150),
          child: Stack(
            children: <Widget>[
              // theme carousel
              PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _controller,
                children: _buildItems(),
              ),

              // left button
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Icon(
                    Icons.chevron_left,
                    size: 32,
                    color: leftIconColor,
                  ),
                ),
              ),

              // right button
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(
                    Icons.chevron_right,
                    size: 32,
                    color: rightIconColor,
                  ),
                ),
              ),

              // previous / next gesture detection
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: _previous,
                      behavior: HitTestBehavior.translucent,
                    ),
                  ),
                  const Spacer(),
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: _next,
                      behavior: HitTestBehavior.translucent,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
