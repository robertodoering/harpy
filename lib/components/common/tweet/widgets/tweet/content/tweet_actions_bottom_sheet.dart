import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';
import 'package:intl/intl.dart';

/// Shows a harpy bottom sheet for the tweet actions.
///
/// A [TweetBloc] must be accessible through the [context].
void showTweetActionsBottomSheet(
  BuildContext context, {
  required TweetData tweet,
}) {
  final theme = Theme.of(context);
  final bloc = context.read<TweetBloc>();
  final authBloc = context.read<AuthenticationBloc>();
  final homeTimelineBloc = context.read<HomeTimelineBloc>();

  final isAuthenticatedUser =
      bloc.state.tweet.user.id == authBloc.authenticatedUser!.id;

  final showReply =
      ModalRoute.of(context)!.settings.name != ComposeScreen.route;

  final tweetTime =
      DateFormat.yMMMd(Localizations.localeOf(context).languageCode)
          .add_Hm()
          .format(tweet.createdAt.toLocal())
          .toLowerCase();

  showHarpyBottomSheet<void>(
    context,
    hapticFeedback: true,
    children: <Widget>[
      BottomSheetHeader(
        child: Column(
          children: <Widget>[
            Text('tweet from ${tweet.user.name}'),
            defaultSmallVerticalSpacer,
            Text(tweetTime),
            // todo: add source here and make bottom sheet scrollable
          ],
        ),
      ),
      if (isAuthenticatedUser)
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
              homeTimelineBloc.add(
                RemoveFromHomeTimeline(tweet: bloc.state.tweet),
              );
            }));
            app<HarpyNavigator>().state!.maybePop();
          },
        ),
      if (showReply)
        ListTile(
          leading: const Icon(CupertinoIcons.reply),
          title: const Text('reply'),
          onTap: () async {
            await app<HarpyNavigator>().state!.maybePop();
            app<HarpyNavigator>().pushComposeScreen(
              inReplyToStatus: tweet,
            );
          },
        ),
      ListTile(
        leading: const Icon(CupertinoIcons.square_arrow_left),
        title: const Text('open tweet externally'),
        onTap: () {
          bloc.add(OpenTweetExternally(tweet: tweet));
          app<HarpyNavigator>().state!.maybePop();
        },
      ),
      ListTile(
        leading: const Icon(CupertinoIcons.square_on_square),
        title: const Text('copy tweet text'),
        enabled: bloc.state.tweet.hasText,
        onTap: () {
          bloc.add(CopyTweetText(tweet: tweet));
          app<HarpyNavigator>().state!.maybePop();
        },
      ),
      ListTile(
        leading: const Icon(CupertinoIcons.share),
        title: const Text('share tweet'),
        onTap: () {
          bloc.add(ShareTweet(tweet: tweet));
          app<HarpyNavigator>().state!.maybePop();
        },
      ),
    ],
  );
}
