import 'dart:ui' as ui show Gradient;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:harpy/components/screens/setup_screen.dart';
import 'package:harpy/components/widgets/shared/animations.dart';
import 'package:harpy/core/misc/harpy_theme.dart';
import 'package:harpy/models/settings/theme_settings_model.dart';

/// A theme selection carousel used in the [SetupScreen].
///
/// The carousel contains the [PredefinedThemes] and changes the selected
/// [HarpyTheme].
class ThemeSelection extends StatefulWidget {
  const ThemeSelection({
    this.delay = Duration.zero,
  });

  /// The delay until gestures to change the theme are registered.
  ///
  /// Used to prevent theme changes when the [ThemeSelection] is still invisible
  /// in the [SetupScreen].
  final Duration delay;

  @override
  _ThemeSelectionState createState() => _ThemeSelectionState();
}

class _ThemeSelectionState extends State<ThemeSelection> {
  final _duration = const Duration(milliseconds: 300);
  final _curve = Curves.easeOutCubic;

  final List<HarpyTheme> _themes = PredefinedThemes.themes;

  PageController _controller;

  bool _lockGestures = true;

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

    Future.delayed(widget.delay).then((_) {
      setState(() {
        _lockGestures = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  List<Widget> _buildItems() {
    return _themes.map((theme) {
      return Center(
        child: CustomPaint(
          size: const Size(60, 60),
          painter: ThemeCirclePainter(
            theme,
            _currentPage == _themes.indexOf(theme),
          ),
        ),
      );
    }).toList();
  }

  void _previous() {
    if (_canPrevious) {
      _controller.previousPage(duration: _duration, curve: _curve);
      _onSelectionChange(_currentPage - 1);
    }
  }

  void _next() {
    if (_canNext) {
      _controller.nextPage(duration: _duration, curve: _curve);

      _onSelectionChange(_currentPage + 1);
    }
  }

  void _onSelectionChange(int index) {
    ThemeSettingsModel.of(context).changeSelectedTheme(_themes[index], index);
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = IconTheme.of(context).color;
    final leftIconColor = iconColor.withOpacity(_canPrevious ? 0.8 : 0.2);
    final rightIconColor = iconColor.withOpacity(_canNext ? 0.8 : 0.2);

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: SlideFadeInAnimation(
            child: Text(
              _themes[_currentPage].name,
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                letterSpacing: 2,
              ),
            ),
          ),
        ),
        Expanded(
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
                  child:
                      Icon(Icons.chevron_left, size: 32, color: leftIconColor),
                ),
              ),

              // right button
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(Icons.chevron_right,
                      size: 32, color: rightIconColor),
                ),
              ),

              // previous / next gesture detection
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: _lockGestures ? null : _previous,
                      behavior: HitTestBehavior.translucent,
                    ),
                  ),
                  Expanded(child: Container()),
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: _lockGestures ? null : _next,
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

/// A circle for a [theme].
class ThemeCirclePainter extends CustomPainter {
  const ThemeCirclePainter(this.theme, this.selected);

  final HarpyTheme theme;
  final bool selected;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;

    canvas.drawCircle(
      size.center(Offset.zero),
      radius,
      Paint()
        ..shader = ui.Gradient.linear(
          size.topLeft(Offset.zero),
          size.bottomRight(Offset.zero),
          [theme.backgroundColors.first, theme.backgroundColors.last],
        ),
    );

    if (selected) {
      canvas.drawCircle(
        size.center(Offset.zero),
        size.width / 2,
        Paint()
          ..style = PaintingStyle.stroke
          ..color = theme.backgroundComplimentaryColor
          ..strokeWidth = 2
          ..isAntiAlias = true
          ..maskFilter = const MaskFilter.blur(BlurStyle.inner, .5),
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    if (old is ThemeCirclePainter) {
      return old.selected != selected;
    }

    return false;
  }
}
