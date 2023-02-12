import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';

void showTweetActionsBottomSheet(
  WidgetRef ref, {
  required LegacyTweetData tweet,
  required TweetDelegates delegates,
}) {
  final theme = Theme.of(ref.context);

  final authenticationState = ref.read(authenticationStateProvider);
  final isAuthenticatedUser = tweet.user.id == authenticationState.user?.id;

  final l10n = Localizations.of<MaterialLocalizations>(
    ref.context,
    MaterialLocalizations,
  )!;
  final general = ref.watch(generalPreferencesProvider);

  final date = l10n.formatFullDate(tweet.createdAt.toLocal());
  final time = l10n.formatTimeOfDay(
    TimeOfDay.fromDateTime(tweet.createdAt.toLocal()),
    alwaysUse24HourFormat: general.alwaysUse24HourFormat,
  );

  showRbyBottomSheet<void>(
    ref.context,
    children: [
      BottomSheetHeader(
        child: Column(
          children: [
            Text(tweet.user.name),
            VerticalSpacer.small,
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
        RbyListTile(
          leading: Icon(CupertinoIcons.delete, color: theme.colorScheme.error),
          title: Text(
            'delete',
            style: TextStyle(
              color: theme.colorScheme.error,
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
        RbyListTile(
          leading: const Icon(CupertinoIcons.reply),
          title: const Text('reply'),
          onTap: () async {
            delegates.onComposeReply?.call(ref);
            Navigator.of(ref.context).pop();
          },
        ),
      RbyListTile(
        leading: const Icon(CupertinoIcons.square_arrow_left),
        title: const Text('open tweet externally'),
        onTap: () {
          delegates.onOpenTweetExternally?.call(ref);
          Navigator.of(ref.context).pop();
        },
      ),
      RbyListTile(
        leading: const Icon(CupertinoIcons.square_on_square),
        title: const Text('copy tweet text'),
        enabled: tweet.hasText,
        onTap: () {
          delegates.onCopyText?.call(ref);
          Navigator.of(ref.context).pop();
        },
      ),
      RbyListTile(
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
