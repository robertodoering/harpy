import 'package:flutter/material.dart';
import 'package:harpy/components/common/buttons/action_button.dart';
import 'package:harpy/components/tweet/bloc/tweet_bloc.dart';
import 'package:harpy/components/tweet/bloc/tweet_event.dart';
import 'package:harpy/components/tweet/bloc/tweet_state.dart';
import 'package:harpy/core/theme/harpy_theme.dart';
import 'package:like_button/like_button.dart';

/// The translation button for the [TweetActionRow].
class TranslationButton extends StatelessWidget {
  const TranslationButton(this.bloc);

  final TweetBloc bloc;

  @override
  Widget build(BuildContext context) {
    final HarpyTheme harpyTheme = HarpyTheme.of(context);

    final bool active =
        bloc.tweet.hasTranslation || bloc.state is TranslatingTweetState;

    return ActionButton(
      active: active,
      activate: () => bloc.add(const TranslateTweet()),
      bubblesColor: const BubblesColor(
        dotPrimaryColor: Colors.teal,
        dotSecondaryColor: Colors.tealAccent,
        dotThirdColor: Colors.lightBlue,
        dotLastColor: Colors.indigoAccent,
      ),
      circleColor: const CircleColor(
        start: Colors.tealAccent,
        end: Colors.lightBlueAccent,
      ),
      iconBuilder: (BuildContext context, bool active, double size) => Icon(
        Icons.translate,
        size: size,
        color: active ? harpyTheme.translateColor : null,
      ),
      iconSize: 20,
    );
  }
}
