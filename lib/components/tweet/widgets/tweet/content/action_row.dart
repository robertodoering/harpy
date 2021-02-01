import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:harpy/components/common/buttons/favorite_button.dart';
import 'package:harpy/components/common/buttons/harpy_button.dart';
import 'package:harpy/components/common/buttons/retweet_button.dart';
import 'package:harpy/components/common/buttons/translation_button.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';
import 'package:harpy/components/tweet/bloc/tweet_bloc.dart';
import 'package:harpy/components/tweet/bloc/tweet_state.dart';
import 'package:harpy/core/api/twitter/tweet_data.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/misc/harpy_navigator.dart';

/// Builds the buttons with actions for the [tweet].
class TweetActionRow extends StatelessWidget {
  const TweetActionRow(this.tweet);

  final TweetData tweet;

  @override
  Widget build(BuildContext context) {
    final TweetBloc bloc = TweetBloc.of(context);
    final RouteSettings route = ModalRoute.of(context).settings;

    return BlocBuilder<TweetBloc, TweetState>(
      builder: (BuildContext context, TweetState state) => Row(
        children: <Widget>[
          RetweetButton(bloc, padding: DefaultEdgeInsets.all()),
          FavoriteButton(bloc, padding: DefaultEdgeInsets.all()),
          if (!tweet.currentReplyParent(route))
            HarpyButton.flat(
              onTap: () => app<HarpyNavigator>().pushRepliesScreen(
                tweet: tweet,
              ),
              icon: const Icon(FeatherIcons.messageSquare),
              iconSize: 22,
              padding: DefaultEdgeInsets.all(),
            ),
          const Spacer(),
          if (tweet.translatable || tweet.quoteTranslatable)
            TweetTranslationButton(bloc, padding: DefaultEdgeInsets.all()),
        ],
      ),
    );
  }
}
