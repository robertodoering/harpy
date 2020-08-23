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
class ThemeSelectionCarousel extends StatefulWidget {
  const ThemeSelectionCarousel();

  @override
  _ThemeSelectionCarouselState createState() => _ThemeSelectionCarouselState();
}

class _ThemeSelectionCarouselState extends State<ThemeSelectionCarousel> {
  PageController _controller;

  int _currentPage = 0;

  bool get _canPrevious => _currentPage > 0;
  bool get _canNext => _currentPage < predefinedThemes.length - 1;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: .3)..addListener(_listener);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _listener() {
    final int currentPage = _controller.page.round();

    if (_currentPage != currentPage) {
      setState(() {
        _currentPage = currentPage;
      });
    }
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

  void _previous(ApplicationBloc applicationBloc) {
    if (_canPrevious) {
      _controller.previousPage(
        duration: kShortAnimationDuration,
        curve: Curves.easeOutCubic,
      );
      _onSelectionChange(applicationBloc, _currentPage - 1);
    }
  }

  void _next(ApplicationBloc applicationBloc) {
    if (_canNext) {
      _controller.nextPage(
        duration: kShortAnimationDuration,
        curve: Curves.easeOutCubic,
      );

      _onSelectionChange(applicationBloc, _currentPage + 1);
    }
  }

  void _onSelectionChange(ApplicationBloc applicationBloc, int index) {
    applicationBloc.add(
      ChangeThemeEvent(id: index, saveSelection: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ApplicationBloc applicationBloc = ApplicationBloc.of(context);

    final Color iconColor = IconTheme.of(context).color;
    final Color leftIconColor = iconColor.withOpacity(_canPrevious ? 0.8 : 0.2);
    final Color rightIconColor = iconColor.withOpacity(_canNext ? 0.8 : 0.2);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        FadeAnimation(
          duration: kShortAnimationDuration,
          child: Text(
            predefinedThemes[_currentPage].name,
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
                      onTap: () => _previous(applicationBloc),
                      behavior: HitTestBehavior.translucent,
                    ),
                  ),
                  const Spacer(),
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () => _next(applicationBloc),
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
