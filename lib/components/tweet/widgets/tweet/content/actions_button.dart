import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/authentication/bloc/authentication_bloc.dart';
import 'package:harpy/components/common/buttons/view_more_action_button.dart';
import 'package:harpy/components/compose/widget/compose_screen.dart';
import 'package:harpy/components/timeline/home_timeline/bloc/home_timeline_bloc.dart';
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

  bool _shouldShowReply(BuildContext context) {
    return ModalRoute.of(context).settings?.name != ComposeScreen.route;
  }

  bool _isAuthenticatedUser(TweetBloc bloc, AuthenticationBloc authBloc) {
    return bloc.tweet.userData.idStr == authBloc.authenticatedUser.idStr;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TweetBloc bloc = TweetBloc.of(context);
    final AuthenticationBloc authBloc = AuthenticationBloc.of(context);
    final HomeTimelineBloc homeTimelineBloc = context.watch<HomeTimelineBloc>();

    return ViewMoreActionButton(
      padding: padding,
      children: <Widget>[
        if (_isAuthenticatedUser(bloc, authBloc))
          ListTile(
            leading: Icon(CupertinoIcons.delete, color: theme.errorColor),
            title: Text(
              'delete',
              style: TextStyle(
                color: theme.errorColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              bloc.add(DeleteTweet(onDeleted: () {
                homeTimelineBloc.add(RemoveFromHomeTimeline(tweet: bloc.tweet));
              }));
              app<HarpyNavigator>().state.maybePop();
            },
          ),
        if (_shouldShowReply(context))
          ListTile(
            leading: const Icon(CupertinoIcons.reply),
            title: const Text('reply'),
            onTap: () async {
              await app<HarpyNavigator>().state.maybePop();
              app<HarpyNavigator>().pushComposeScreen(
                inReplyToStatus: tweet,
              );
            },
          ),
        ListTile(
          leading: const Icon(CupertinoIcons.square_arrow_left),
          title: const Text('open externally'),
          onTap: () {
            bloc.add(OpenTweetExternally(tweet: tweet));
            app<HarpyNavigator>().state.maybePop();
          },
        ),
        ListTile(
          leading: const Icon(CupertinoIcons.square_on_square),
          title: const Text('copy text'),
          enabled: bloc.tweet.hasText,
          onTap: () {
            bloc.add(CopyTweetText(tweet: tweet));
            app<HarpyNavigator>().state.maybePop();
          },
        ),
        ListTile(
          leading: const Icon(CupertinoIcons.share),
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
