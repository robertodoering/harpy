import 'package:flutter/material.dart';
import 'package:harpy/components/widgets/shared/animations.dart';
import 'package:harpy/models/login_model.dart';

/// The [InitializationScreen] is shown when a user logged into the app for
/// the first time.
class InitializationScreen extends StatelessWidget {
  final GlobalKey<SlideAnimationState> _slideInitializationKey =
      GlobalKey<SlideAnimationState>();

  Widget _buildInitializationScreen(BuildContext context) {
    return SlideAnimation(
      key: _slideInitializationKey,
      duration: const Duration(milliseconds: 600),
      endPosition: Offset(0, -MediaQuery.of(context).size.height),
      child: Column(
        children: <Widget>[
          _buildText(context),
        ],
      ),
    );
  }

  Widget _buildText(BuildContext context) {
    final loginModel = LoginModel.of(context);

    return Expanded(
      flex: 2,
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
          SizedBox(height: 16),
          SubtitleText(
            "please take a moment to setup your experience",
            textAlign: TextAlign.center,
            delay: const Duration(milliseconds: 3000),
          ),
        ],
      ),
    );
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

// todo: move to different file
class TitleText extends StatelessWidget {
  const TitleText(
    this.text, {
    this.fontSize,
    this.overflow,
    this.delay = Duration.zero,
  });

  final String text;
  final double fontSize;
  final TextOverflow overflow;

  final Duration delay;

  @override
  Widget build(BuildContext context) {
    return SlideFadeInAnimation(
      duration: Duration(seconds: 2),
      delay: delay,
      offset: Offset(0.0, 75.0),
      child: Text(
        text,
        overflow: overflow,
        style: Theme.of(context).textTheme.title.copyWith(fontSize: fontSize),
      ),
      curve: Curves.easeOutCubic,
    );
  }
}

class SubtitleText extends StatelessWidget {
  const SubtitleText(
    this.text, {
    this.textAlign,
    this.delay = Duration.zero,
  });

  final String text;
  final TextAlign textAlign;

  final Duration delay;

  @override
  Widget build(BuildContext context) {
    return SlideFadeInAnimation(
      delay: delay,
      duration: Duration(seconds: 1),
      offset: Offset(0.0, 50.0),
      child: Text(
        text,
        textAlign: textAlign,
        style: Theme.of(context).textTheme.subtitle,
      ),
      curve: Curves.easeInOut,
    );
  }
}
