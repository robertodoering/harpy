import 'package:flutter/material.dart';
import 'package:harpy/components/common/buttons/view_more_action_button.dart';
import 'package:harpy/components/tweet/bloc/tweet_bloc.dart';
import 'package:harpy/components/tweet/bloc/tweet_event.dart';
import 'package:harpy/core/api/twitter/tweet_data.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/misc/harpy_navigator.dart';

class TweetActionsButton extends StatelessWidget {
  const TweetActionsButton(
    this.tweet, {
    this.sizeDelta = 0,
  });

  final TweetData tweet;
  final double sizeDelta;

  @override
  Widget build(BuildContext context) {
    final TweetBloc bloc = TweetBloc.of(context);

    return ViewMoreActionButton(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        ListTile(
          leading: const Icon(Icons.open_in_browser),
          title: const Text('Open externally'),
          onTap: () {
            bloc.add(OpenTweetExternally(tweet: tweet));
            app<HarpyNavigator>().state.maybePop();
          },
        ),
        ListTile(
          leading: const Icon(Icons.copy),
          title: const Text('Copy text'),
          enabled: bloc.tweet.hasText,
          onTap: () {
            bloc.add(CopyTweetText(tweet: tweet));
            app<HarpyNavigator>().state.maybePop();
          },
        ),
        ListTile(
          leading: const Icon(Icons.share),
          title: const Text('Share Tweet'),
          onTap: () {
            bloc.add(ShareTweet(tweet: tweet));
            app<HarpyNavigator>().state.maybePop();
          },
        ),
      ],
    );
  }
}
