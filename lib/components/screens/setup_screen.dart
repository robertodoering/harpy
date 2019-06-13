import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:harpy/components/screens/home_screen.dart';
import 'package:harpy/components/widgets/shared/animations.dart';
import 'package:harpy/components/widgets/shared/buttons.dart';
import 'package:harpy/components/widgets/shared/texts.dart';
import 'package:harpy/core/misc/harpy_navigator.dart';
import 'package:harpy/models/login_model.dart';

/// The [SetupScreen] is shown when a user logged into the app for the first
/// time.
class SetupScreen extends StatelessWidget {
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
          SubtitleText("welcome"),
          SizedBox(height: 16),
          TitleText(
            loginModel.loggedInUser.name,
            fontSize: 48,
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
          SubtitleText(
            "select your theme",
            textAlign: TextAlign.center,
            delay: const Duration(milliseconds: 3000),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ThemeSelection(),
          ),
          Spacer(),
          BounceInAnimation(
            delay: const Duration(milliseconds: 4000),
            child: HarpyButton.flat(
              text: "continue",
              textColor: Colors.white,
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
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: <Color>[Colors.black, Color(0xff17233d)],
          ),
        ),
        child: _buildInitializationScreen(context),
      ),
    );
  }
}

// todo
class ThemeSelection extends StatelessWidget {
  final List<Color> _themes = <Color>[
    Colors.blue,
    Colors.red,
    Colors.white,
    Colors.black,
  ];

  Widget _itemBuilder(BuildContext context, int index) {
    return CircleAvatar(backgroundColor: _themes[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Swiper(
      itemCount: _themes.length,
      itemBuilder: _itemBuilder,
    );
  }
}
