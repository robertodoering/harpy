import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/components/pages/user/widgets/user_page_avatar.dart';
import 'package:harpy/core/core.dart';
import 'package:rby/rby.dart';

class UserPageInfo extends StatelessWidget {
  const UserPageInfo({
    required this.data,
    required this.notifier,
    required this.isAuthenticatedUser,
  });

  final UserPageData data;
  final UserPageNotifier notifier;
  final bool isAuthenticatedUser;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const SizedBox(height: UserPageAvatar.minAvatarRadius),
            if (!isAuthenticatedUser && data.relationship != null) ...[
              if (data.relationship!.muting)
                _MutedButton(
                  data: data,
                  notifier: notifier,
                ),
              _RelationshipButton(
                user: data.user,
                relationship: data.relationship!,
                notifier: notifier,
              ),
            ],
          ],
        ),
        _Name(user: data.user),
        VerticalSpacer.small,
        _Handle(user: data.user),
      ],
    );
  }
}

class _Name extends StatelessWidget {
  const _Name({
    required this.user,
  });

  final UserData user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: theme.spacing.symmetric(horizontal: true),
      child: FittedBox(
        child: Text.rich(
          TextSpan(
            style: theme.textTheme.headlineSmall,
            children: [
              TextSpan(text: user.name),
              if (user.isProtected) ...[
                const TextSpan(text: ' '),
                WidgetSpan(
                  child: Icon(
                    CupertinoIcons.lock,
                    size: theme.iconTheme.size,
                  ),
                  baseline: TextBaseline.alphabetic,
                ),
              ],
              if (user.isVerified) ...[
                const TextSpan(text: ' '),
                WidgetSpan(
                  child: Icon(
                    CupertinoIcons.checkmark_seal_fill,
                    size: theme.iconTheme.size,
                  ),
                  baseline: TextBaseline.alphabetic,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Handle extends ConsumerWidget {
  const _Handle({
    required this.user,
  });

  final UserData user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final handle = '@${user.handle}';

    return GestureDetector(
      onLongPress: () {
        HapticFeedback.lightImpact();
        Clipboard.setData(ClipboardData(text: handle));
        ref.read(messageServiceProvider).showText('copied $handle');
      },
      child: Padding(
        padding: theme.spacing.symmetric(horizontal: true),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            handle,
            textDirection: TextDirection.ltr,
            style: theme.textTheme.titleMedium,
          ),
        ),
      ),
    );
  }
}

class _MutedButton extends StatelessWidget {
  const _MutedButton({
    required this.data,
    required this.notifier,
  });

  final UserPageData data;
  final UserPageNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RbyButton.text(
      icon: Icon(
        CupertinoIcons.volume_off,
        color: theme.colorScheme.onBackground,
        size: theme.iconTheme.size! - 2,
      ),
      onTap: () => showDialog<void>(
        context: context,
        builder: (_) => RbyDialog(
          title: Text('unmute @${data.user.handle}?'),
          actions: [
            RbyButton.text(
              label: const Text('cancel'),
              onTap: Navigator.of(context).pop,
            ),
            RbyButton.elevated(
              label: const Text('unmute'),
              onTap: () {
                notifier.unmute().ignore();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _RelationshipButton extends StatelessWidget {
  const _RelationshipButton({
    required this.user,
    required this.relationship,
    required this.notifier,
  });

  final UserData user;
  final RelationshipData relationship;
  final UserPageNotifier notifier;

  String _resolveLabel() {
    if (relationship.blocking) {
      return 'blocked';
    } else if (relationship.following) {
      return 'following';
    } else if (relationship.followingRequested) {
      return 'pending';
    } else if (user.isProtected) {
      return 'request';
    }

    return 'follow';
  }

  Color? _resolveColor(ThemeData theme) {
    if (relationship.blocking) {
      return theme.colorScheme.error;
    } else if (!relationship.following && !relationship.followingRequested) {
      return theme.colorScheme.onBackground;
    }

    return null;
  }

  void _showBlockedDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => RbyDialog(
        title: Text('unblock @${user.handle}?'),
        actions: [
          RbyButton.text(
            label: const Text('cancel'),
            onTap: Navigator.of(context).pop,
          ),
          RbyButton.elevated(
            label: const Text('unblock'),
            onTap: () {
              notifier.unblock().ignore();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _toggleFollow() {
    HapticFeedback.lightImpact();
    if (relationship.following || relationship.followingRequested) {
      notifier.unfollow();
    } else {
      notifier.follow();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RbyButton.text(
      label: Text(
        _resolveLabel(),
        style: TextStyle(color: _resolveColor(theme)),
      ),
      onTap: relationship.blocking
          ? () => _showBlockedDialog(context)
          : _toggleFollow,
    );
  }
}
