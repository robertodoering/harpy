import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:harpy/components/screens/home_screen.dart';
import 'package:harpy/components/widgets/shared/animations.dart';
import 'package:harpy/components/widgets/shared/buttons.dart';
import 'package:harpy/components/widgets/shared/harpy_background.dart';
import 'package:harpy/components/widgets/shared/texts.dart';
import 'package:harpy/core/misc/harpy_navigator.dart';
import 'package:harpy/core/misc/harpy_theme.dart';
import 'package:harpy/models/login_model.dart';
import 'package:harpy/models/settings/theme_settings_model.dart';

/// The [SetupScreen] is shown when a user logged into the app for the first
/// time.
class SetupScreen extends StatefulWidget {
  @override
  _SetupScreenState createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final GlobalKey<SlideAnimationState> _slideInitializationKey =
      GlobalKey<SlideAnimationState>();

  Widget _buildInitializationScreen(BuildContext context) {
    return SlideAnimation(
      key: _slideInitializationKey,
      duration: const Duration(milliseconds: 600),
      endPosition: Offset(0, -MediaQuery.of(context).size.height),
      child: Column(
        children: <Widget>[
          _buildTop(context),
          _buildBottom(),
        ],
      ),
    );
  }

  Widget _buildTop(BuildContext context) {
    final loginModel = LoginModel.of(context);

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SecondaryDisplayText("welcome"),
          SizedBox(height: 16),
          PrimaryDisplayText(
            loginModel.loggedInUser.name,
            style: Theme.of(context).textTheme.display3,
            overflow: TextOverflow.ellipsis,
            delay: const Duration(milliseconds: 800),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildBottom() {
    return Expanded(
      child: Column(
        children: <Widget>[
          SizedBox(height: 8),
          SecondaryDisplayText(
            "select your theme",
            textAlign: TextAlign.center,
            delay: const Duration(milliseconds: 3000),
          ),
          SizedBox(height: 16),
          Expanded(
            child: SlideFadeInAnimation(
              delay: const Duration(milliseconds: 3000),
              duration: const Duration(seconds: 1),
              offset: const Offset(0.0, 50.0),
              curve: Curves.easeInOut,
              child: ThemeSelection(),
            ),
          ),
          Spacer(),
          BounceInAnimation(
            delay: const Duration(milliseconds: 4000),
            child: NewFlatHarpyButton(
              text: "continue",
              onTap: _navigateToHome,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _navigateToHome() async {
    await _slideInitializationKey.currentState.forward();
    HarpyNavigator.pushReplacement(HomeScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: HarpyBackground(
        child: _buildInitializationScreen(context),
      ),
    );
  }
}

// todo
// todo: prevent gestures before the theme selection shows on screen
class ThemeSelection extends StatefulWidget {
  @override
  _ThemeSelectionState createState() => _ThemeSelectionState();
}

class _ThemeSelectionState extends State<ThemeSelection> {
  final _duration = const Duration(milliseconds: 300);
  final _curve = Curves.easeOutCubic;

  final List<HarpyTheme> _themes = PredefinedThemes.themes;

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
    final themeSettingsModel = ThemeSettingsModel.of(context);

    themeSettingsModel.changeSelectedTheme(_themes[index], index);
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
                letterSpacing: 2.0,
              ),
            ),
          ),
        ),
        Expanded(
          child: Stack(
            children: <Widget>[
              // theme carousel
              PageView(
                physics: NeverScrollableScrollPhysics(),
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
                      onTap: _previous,
                      behavior: HitTestBehavior.translucent,
                    ),
                  ),
                  Expanded(child: Container()),
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
          theme.backgroundColors,
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
          ..maskFilter = MaskFilter.blur(BlurStyle.inner, .5),
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
