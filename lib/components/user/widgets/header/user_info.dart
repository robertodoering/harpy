import 'package:built_collection/built_collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:rby/rby.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({
    required this.user,
    required this.connections,
    required this.connectionsNotifier,
  });

  final UserData user;
  final BuiltSet<UserConnection>? connections;
  final UserConnectionsNotifier connectionsNotifier;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: theme.spacing.edgeInsets,
            child: _Avatar(user: user),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Name(user: user),
                VerticalSpacer.small,
                _Handle(user: user),
              ],
            ),
          ),
          AnimatedSize(
            duration: theme.animation.short,
            curve: Curves.easeOutCubic,
            child: RbyAnimatedSwitcher(
              child: connections != null
                  ? _FollowButton(
                      user: user,
                      following: connections!.contains(
                        UserConnection.following,
                      ),
                      notifier: connectionsNotifier,
                    )
                  : const SizedBox(),
            ),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({
    required this.user,
  });

  final UserData user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showFullscreenAvatar(context, user: user),
      child: HarpyCircleAvatar(
        radius: 28,
        imageUrl: user.originalUserImageUrl,
        heroTag: user.originalUserImageUrl,
      ),
    );
  }
}

void _showFullscreenAvatar(
  BuildContext context, {
  required UserData user,
}) {
  Navigator.of(context).push<void>(
    HeroDialogRoute(
      builder: (_) => HarpyDismissible(
        onDismissed: Navigator.of(context).pop,
        child: HarpyPhotoGallery(
          itemCount: 1,
          builder: (_, __) => Hero(
            tag: user.originalUserImageUrl,
            flightShuttleBuilder: (
              flightContext,
              animation,
              flightDirection,
              fromHeroContext,
              toHeroContext,
            ) =>
                borderRadiusFlightShuttleBuilder(
              BorderRadius.circular(48),
              animation,
              flightDirection,
              fromHeroContext,
              toHeroContext,
            ),
            child: HarpyImage(
              imageUrl: user.originalUserImageUrl,
            ),
          ),
        ),
      ),
    ),
  );
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
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          handle,
          textDirection: TextDirection.ltr,
          style: theme.textTheme.subtitle1,
        ),
      ),
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

    return FittedBox(
      child: Text.rich(
        TextSpan(
          style: theme.textTheme.headline5,
          children: [
            TextSpan(text: user.name),
            if (user.verified) ...[
              const TextSpan(text: ' '),
              WidgetSpan(
                child: Icon(
                  CupertinoIcons.checkmark_seal_fill,
                  size: theme.iconTheme.size! + 2,
                ),
                baseline: TextBaseline.alphabetic,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _FollowButton extends StatelessWidget {
  const _FollowButton({
    required this.user,
    required this.following,
    required this.notifier,
  });

  final UserData user;
  final bool following;
  final UserConnectionsNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RbyButton.text(
      padding: theme.spacing.edgeInsets,
      label: following
          ? const Text('following')
          : Text(
              'follow',
              style: TextStyle(color: theme.colorScheme.onBackground),
            ),
      onTap: () {
        HapticFeedback.lightImpact();
        if (following) {
          notifier.unfollow(user.handle);
        } else {
          notifier.follow(user.handle);
        }
      },
    );
  }
}
