import 'package:flutter/material.dart';
import 'package:harpy/components/authentication/bloc/authentication_bloc.dart';
import 'package:harpy/components/authentication/widgets/headlines.dart';
import 'package:harpy/components/authentication/widgets/theme_selection_carousel.dart';
import 'package:harpy/components/common/animations/explicit/bounce_in_animation.dart';
import 'package:harpy/components/common/animations/explicit/fade_animation.dart';
import 'package:harpy/components/common/animations/explicit/slide_animation.dart';
import 'package:harpy/components/common/animations/explicit/slide_in_animation.dart';
import 'package:harpy/components/common/buttons/harpy_button.dart';
import 'package:harpy/components/common/misc/harpy_background.dart';
import 'package:harpy/components/settings/theme_selection/bloc/theme_bloc.dart';
import 'package:harpy/components/timeline/home_timeline/widgets/home_screen.dart';
import 'package:harpy/core/analytics_service.dart';
import 'package:harpy/core/preferences/setup_preferences.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/misc/harpy_navigator.dart';

/// The [SetupScreen] is shown when a user logged into the app for the first
/// time.
class SetupScreen extends StatefulWidget {
  const SetupScreen();

  static const String route = 'setup';

  @override
  _SetupScreenState createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final GlobalKey<SlideAnimationState> _slideSetupKey =
      GlobalKey<SlideAnimationState>();

  Future<void> _continue(ThemeBloc themeBloc) async {
    // setup completed
    await _slideSetupKey.currentState.forward();

    app<SetupPreferences>().performedSetup = true;
    app<AnalyticsService>().logSetupTheme(themeBloc.harpyTheme.name);

    app<HarpyNavigator>().pushReplacementNamed(
      HomeScreen.route,
      type: RouteType.fade,
    );
  }

  Widget _buildText() {
    return const Align(
      alignment: Alignment.bottomCenter,
      child: SecondaryHeadline('welcome'),
    );
  }

  Widget _buildUsername(AuthenticationBloc authenticationBloc) {
    return Center(
      child: PrimaryHeadline(
        '${authenticationBloc.authenticatedUser.name}',
        delay: const Duration(milliseconds: 800),
      ),
    );
  }

  Widget _buildThemeSelection(ThemeData theme) {
    return FadeAnimation(
      curve: Curves.easeInOut,
      duration: const Duration(seconds: 1),
      delay: const Duration(milliseconds: 3000),
      child: SlideInAnimation(
        duration: const Duration(seconds: 1),
        curve: Curves.easeOut,
        offset: const Offset(0, 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('select your theme', style: theme.textTheme.headline4),
            const SizedBox(height: 16),
            const ThemeSelectionCarousel(),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton(ThemeBloc themeBloc) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: BounceInAnimation(
        delay: const Duration(milliseconds: 4000),
        child: HarpyButton.flat(
          text: const Text('continue'),
          onTap: () => _continue(themeBloc),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final ThemeData theme = Theme.of(context);

    final ThemeBloc themeBloc = ThemeBloc.of(context);
    final AuthenticationBloc authenticationBloc =
        AuthenticationBloc.of(context);

    // the max height constraints for the welcome text and the user name
    final double maxTextHeight = mediaQuery.orientation == Orientation.portrait
        ? mediaQuery.size.height / 4
        : mediaQuery.size.height / 6;

    return HarpyBackground(
      child: SlideAnimation(
        key: _slideSetupKey,
        endPosition: Offset(0, -mediaQuery.size.height),
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(top: mediaQuery.padding.top),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: maxTextHeight),
                      child: _buildText(),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: maxTextHeight),
                      child: _buildUsername(authenticationBloc),
                    ),
                    const SizedBox(height: 32),
                    _buildThemeSelection(theme),
                  ],
                ),
              ),
            ),
            _buildContinueButton(themeBloc),
            SizedBox(height: mediaQuery.padding.bottom),
          ],
        ),
      ),
    );
  }
}
