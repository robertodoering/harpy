import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

void showTweetActionsBottomSheet(
  WidgetRef ref, {
  required TweetData tweet,
  required TweetDelegates delegates,
}) {
  final theme = Theme.of(ref.context);

  final authenticationState = ref.read(authenticationStateProvider);
  final isAuthenticatedUser = tweet.user.id == authenticationState.user?.id;

  final l10n = Localizations.of<MaterialLocalizations>(
    ref.context,
    MaterialLocalizations,
  )!;

  final date = l10n.formatFullDate(tweet.createdAt.toLocal());
  final time = l10n.formatTimeOfDay(
    TimeOfDay.fromDateTime(tweet.createdAt.toLocal()),
  );

  showHarpyBottomSheet<void>(
    ref.context,
    harpyTheme: ref.read(harpyThemeProvider),
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
            delegates.onDelete?.call(ref);
            Navigator.of(ref.context).pop();
          },
        ),
      if (delegates.onComposeReply != null)
        HarpyListTile(
          leading: const Icon(CupertinoIcons.reply),
          title: const Text('reply'),
          onTap: () async {
            delegates.onComposeReply?.call(ref);
            Navigator.of(ref.context).pop();
          },
        ),
      HarpyListTile(
        leading: const Icon(CupertinoIcons.square_arrow_left),
        title: const Text('open tweet externally'),
        onTap: () {
          delegates.onOpenTweetExternally?.call(ref);
          Navigator.of(ref.context).pop();
        },
      ),
      HarpyListTile(
        leading: const Icon(CupertinoIcons.square_on_square),
        title: const Text('copy tweet text'),
        enabled: tweet.hasText,
        onTap: () {
          delegates.onCopyText?.call(ref);
          Navigator.of(ref.context).pop();
        },
      ),
      HarpyListTile(
        leading: const Icon(CupertinoIcons.share),
        title: const Text('share tweet'),
        onTap: () {
          delegates.onShareTweet?.call(ref);
          Navigator.of(ref.context).pop();
        },
      ),
    ],
  );
}
