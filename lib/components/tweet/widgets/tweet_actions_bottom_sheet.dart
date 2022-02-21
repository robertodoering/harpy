import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/services/message_service.dart';
import 'package:harpy/rby/rby.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

void showTweetActionsBottomSheet(
  BuildContext context, {
  required TweetData tweet,
  required Reader read,
}) {
  final theme = Theme.of(context);

  final authenticationState = read(authenticationStateProvider);
  final isAuthenticatedUser = tweet.user.id == authenticationState.user?.id;

  // final showReply =
  //     ModalRoute.of(context)!.settings.name != ComposeScreen.route;

  final tweetTime =
      DateFormat.yMMMd(Localizations.localeOf(context).languageCode)
          .add_Hm()
          .format(tweet.createdAt.toLocal())
          .toLowerCase();

  showHarpyBottomSheet<void>(
    context,
    harpyTheme: read(harpyThemeProvider),
    children: [
      BottomSheetHeader(
        child: Column(
          children: [
            Text('tweet from ${tweet.user.name}'),
            smallVerticalSpacer,
            Text(tweetTime),
          ],
        ),
      ),
      if (isAuthenticatedUser)
        HarpyListTile(
          leading: Icon(CupertinoIcons.delete, color: theme.errorColor),
          title: Text(
            'delete',
            style: TextStyle(
              color: theme.errorColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () {
            // TODO: use delegate for remove tweet callback
            // bloc.add(
            //   TweetEvent.delete(
            //     onDeleted: () => homeTimelineCubit.removeTweet(bloc.tweet),
            //   ),
            // );
            // app<HarpyNavigator>().maybePop();
          },
        ),
      // if (showReply)
      //   HarpyListTile(
      //     leading: const Icon(CupertinoIcons.reply),
      //     title: const Text('reply'),
      //     onTap: () async {
      //       await app<HarpyNavigator>().maybePop();
      //       app<HarpyNavigator>().pushComposeScreen(
      //         inReplyToStatus: tweet,
      //       );
      //     },
      //   ),
      HarpyListTile(
        leading: const Icon(CupertinoIcons.square_arrow_left),
        title: const Text('open tweet externally'),
        onTap: () {
          HapticFeedback.lightImpact();
          launchUrl(tweet.tweetUrl);
          Navigator.of(context).pop();
        },
      ),
      HarpyListTile(
        leading: const Icon(CupertinoIcons.square_on_square),
        title: const Text('copy tweet text'),
        enabled: tweet.hasText,
        onTap: () {
          HapticFeedback.lightImpact();
          Clipboard.setData(ClipboardData(text: tweet.visibleText));
          read(messageServiceProvider).showText('copied tweet text');
          Navigator.of(context).pop();
        },
      ),
      HarpyListTile(
        leading: const Icon(CupertinoIcons.share),
        title: const Text('share tweet'),
        onTap: () {
          HapticFeedback.lightImpact();
          Share.share(tweet.tweetUrl);
          Navigator.of(context).pop();
        },
      ),
    ],
  );
}
