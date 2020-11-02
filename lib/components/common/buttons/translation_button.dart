import 'package:flutter/material.dart';
import 'package:harpy/components/common/buttons/action_button.dart';
import 'package:harpy/components/tweet/bloc/tweet_bloc.dart';
import 'package:harpy/components/tweet/bloc/tweet_event.dart';
import 'package:harpy/components/tweet/bloc/tweet_state.dart';
import 'package:harpy/components/user_profile/bloc/user_profile_bloc.dart';
import 'package:harpy/components/user_profile/bloc/user_profile_event.dart';
import 'package:harpy/components/user_profile/bloc/user_profile_state.dart';
import 'package:harpy/core/theme/harpy_theme.dart';
import 'package:like_button/like_button.dart';

class TranslationButton extends StatelessWidget {
  const TranslationButton({
    @required this.active,
    @required this.activate,
  });

  final bool active;
  final VoidCallback activate;

  @override
  Widget build(BuildContext context) {
    final HarpyTheme harpyTheme = HarpyTheme.of(context);

    return ActionButton(
      active: active,
      activate: activate,
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

/// The translation button for the [TweetActionRow].
class TweetTranslationButton extends StatelessWidget {
  const TweetTranslationButton(this.bloc);

  final TweetBloc bloc;

  @override
  Widget build(BuildContext context) {
    final bool active =
        bloc.tweet.hasTranslation || bloc.state is TranslatingTweetState;

    return TranslationButton(
      active: active,
      activate: () => bloc.add(const TranslateTweet()),
    );
  }
}

/// The translation button for the [UserProfileHeader].
class UserDescriptionTranslationButton extends StatelessWidget {
  const UserDescriptionTranslationButton(this.bloc);

  final UserProfileBloc bloc;

  @override
  Widget build(BuildContext context) {
    final bool active = bloc.user.hasDescriptionTranslation ||
        bloc.state is TranslatingDescriptionState;

    return TranslationButton(
      active: active,
      activate: () => bloc.add(const TranslateUserDescriptionEvent()),
    );
  }
}
