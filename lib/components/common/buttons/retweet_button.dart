import 'package:flutter/material.dart';
import 'package:harpy/components/common/buttons/action_button.dart';
import 'package:harpy/components/tweet/bloc/tweet_bloc.dart';
import 'package:harpy/components/tweet/bloc/tweet_event.dart';
import 'package:harpy/core/theme/harpy_theme.dart';
import 'package:like_button/like_button.dart';

/// The retweet button for a [TweetActionRow].
class RetweetButton extends StatelessWidget {
  const RetweetButton(
    this.bloc, {
    this.padding = const EdgeInsets.all(8),
  });

  final TweetBloc bloc;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final HarpyTheme harpyTheme = HarpyTheme.of(context);

    return ActionButton(
      active: bloc.tweet.retweeted,
      padding: padding,
      activeIconColor: harpyTheme.retweetColor,
      activeTextStyle: TextStyle(
        color: harpyTheme.retweetColor,
        fontWeight: FontWeight.bold,
      ),
      value: bloc.tweet.retweetCount,
      activate: () => bloc.add(const RetweetTweet()),
      deactivate: () => bloc.add(const UnretweetTweet()),
      bubblesColor: BubblesColor(
        dotPrimaryColor: Colors.lime,
        dotSecondaryColor: Colors.limeAccent,
        dotThirdColor: Colors.green,
        dotLastColor: Colors.green[900],
      ),
      circleColor: const CircleColor(
        start: Colors.green,
        end: Colors.lime,
      ),
      iconAnimationBuilder: (Animation<double> animation, Widget child) {
        return RotationTransition(
          turns: CurvedAnimation(
            curve: Curves.easeOutBack,
            parent: animation,
          ),
          child: child,
        );
      },
      iconBuilder: (
        BuildContext context,
        bool active,
        double size,
      ) {
        return Icon(Icons.repeat, size: size);
      },
    );
  }
}
