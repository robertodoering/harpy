import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/services/message_service.dart';
import 'package:harpy/rby/rby.dart';
import 'package:share_plus/share_plus.dart';

void showTweetActionsBottomSheet(
  BuildContext context, {
  required TweetData tweet,
  required TweetDelegates delegates,
  required Reader read,
}) {
  final theme = Theme.of(context);

  final authenticationState = read(authenticationStateProvider);
  final isAuthenticatedUser = tweet.user.id == authenticationState.user?.id;

  final l10n = Localizations.of<MaterialLocalizations>(
    context,
    MaterialLocalizations,
  )!;

  showHarpyBottomSheet<void>(
    context,
    harpyTheme: read(harpyThemeProvider),
    children: [
      BottomSheetHeader(
        child: Column(
          children: [
            Text('tweet from ${tweet.user.name}'),
            smallVerticalSpacer,
            Text(l10n.formatFullDate(tweet.createdAt.toLocal())),
          ],
        ),
      ),
      if (isAuthenticatedUser && delegates.onDeleteTweet != null)
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
            HapticFeedback.lightImpact();
            delegates.onDeleteTweet?.call(context, read);
            Navigator.of(context).pop();
          },
        ),
      if (delegates.onComposeReply != null)
        HarpyListTile(
          leading: const Icon(CupertinoIcons.reply),
          title: const Text('reply'),
          onTap: () async {
            delegates.onComposeReply?.call(context, read);
            Navigator.of(context).pop();
          },
        ),
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
