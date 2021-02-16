import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:harpy/components/common/buttons/view_more_action_button.dart';
import 'package:harpy/components/tweet/bloc/tweet_bloc.dart';
import 'package:harpy/components/tweet/bloc/tweet_event.dart';
import 'package:harpy/core/api/twitter/tweet_data.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/misc/harpy_navigator.dart';

class TweetActionsButton extends StatelessWidget {
  const TweetActionsButton(
    this.tweet, {
    this.padding = const EdgeInsets.all(8),
    this.sizeDelta = 0,
  });

  final TweetData tweet;
  final EdgeInsets padding;
  final double sizeDelta;

  @override
  Widget build(BuildContext context) {
    final TweetBloc bloc = TweetBloc.of(context);

    return ViewMoreActionButton(
      padding: padding,
      children: <Widget>[
        ListTile(
          leading: const Icon(Icons.reply),
          title: const Text('reply'),
          onTap: () async {
            await app<HarpyNavigator>().state.maybePop();
            app<HarpyNavigator>().pushComposeScreen(
              inReplyToStatus: tweet,
            );
          },
        ),
        ListTile(
          leading: const Icon(FeatherIcons.share),
          title: const Text('open externally'),
          onTap: () {
            bloc.add(OpenTweetExternally(tweet: tweet));
            app<HarpyNavigator>().state.maybePop();
          },
        ),
        ListTile(
          leading: const Icon(FeatherIcons.copy),
          title: const Text('copy text'),
          enabled: bloc.tweet.hasText,
          onTap: () {
            bloc.add(CopyTweetText(tweet: tweet));
            app<HarpyNavigator>().state.maybePop();
          },
        ),
        ListTile(
          leading: const Icon(FeatherIcons.share2),
          title: const Text('share tweet'),
          onTap: () {
            bloc.add(ShareTweet(tweet: tweet));
            app<HarpyNavigator>().state.maybePop();
          },
        ),
      ],
    );
  }
}
