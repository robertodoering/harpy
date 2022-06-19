import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

void showTweetActionsBottomSheet(
  BuildContext context, {
  required Reader read,
  required TweetData tweet,
  required TweetDelegates delegates,
}) {
  final theme = Theme.of(context);

  final authenticationState = read(authenticationStateProvider);
  final isAuthenticatedUser = tweet.user.id == authenticationState.user?.id;

  final l10n = Localizations.of<MaterialLocalizations>(
    context,
    MaterialLocalizations,
  )!;

  final date = l10n.formatFullDate(tweet.createdAt.toLocal());
  final time = l10n.formatTimeOfDay(
    TimeOfDay.fromDateTime(tweet.createdAt.toLocal()),
  );

  showHarpyBottomSheet<void>(
    context,
    harpyTheme: read(harpyThemeProvider),
    children: [
      BottomSheetHeader(
        child: Column(
          children: [
            Text(tweet.user.name),
            smallVerticalSpacer,
            Wrap(
              children: [
                Text(time),
                const Text(' \u00b7 '),
                Text(date),
              ],
            ),
          ],
        ),
      ),
      if (isAuthenticatedUser && delegates.onDelete != null)
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
            delegates.onDelete?.call(context, read);
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
          delegates.onOpenTweetExternally?.call(context, read);
          Navigator.of(context).pop();
        },
      ),
      HarpyListTile(
        leading: const Icon(CupertinoIcons.square_on_square),
        title: const Text('copy tweet text'),
        enabled: tweet.hasText,
        onTap: () {
          delegates.onCopyText?.call(context, read);
          Navigator.of(context).pop();
        },
      ),
      HarpyListTile(
        leading: const Icon(CupertinoIcons.share),
        title: const Text('share tweet'),
        onTap: () {
          delegates.onShareTweet?.call(context, read);
          Navigator.of(context).pop();
        },
      ),
    ],
  );
}
