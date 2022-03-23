import 'package:built_collection/built_collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

class UserInfo extends ConsumerWidget {
  const UserInfo({
    required this.user,
    required this.connections,
    required this.connectionsNotifier,
  });

  final UserData user;
  final BuiltSet<UserConnection>? connections;
  final UserConnectionsNotifier connectionsNotifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(displayPreferencesProvider);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: display.edgeInsets,
          child: _Avatar(user: user),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: display
                          .edgeInsetsOnly(
                            top: true,
                            right: true,
                          )
                          .copyWith(bottom: display.paddingValue),
                      child: _Handle(user: user),
                    ),
                  ),
                  AnimatedSize(
                    duration: kShortAnimationDuration,
                    curve: Curves.easeOutCubic,
                    child: AnimatedSwitcher(
                      duration: kShortAnimationDuration,
                      switchInCurve: Curves.easeIn,
                      switchOutCurve: Curves.easeOut,
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
              Padding(
                padding: display.edgeInsetsOnly(right: true),
                child: _Name(user: user),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Avatar extends ConsumerWidget {
  const _Avatar({
    required this.user,
  });

  final UserData user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final display = ref.watch(displayPreferencesProvider);

    // approximate height of available space for handle & name
    final avatarSize = display.paddingValue +
        display.smallPaddingValue +
        theme.textTheme.subtitle1!.fontSize! +
        theme.textTheme.headline6!.fontSize!;

    return GestureDetector(
      onTap: () => _showFullscreenAvatar(context, user: user),
      child: SizedBox(
        width: avatarSize,
        height: avatarSize,
        child: HarpyCircleAvatar(
          radius: 36,
          imageUrl: user.originalUserImageUrl,
          heroTag: user.originalUserImageUrl,
        ),
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
        alignment: Alignment.centerLeft,
        child: Text(handle, style: theme.textTheme.subtitle1),
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
                alignment: PlaceholderAlignment.baseline,
              ),
            ],
          ],
          style: theme.textTheme.headline6,
        ),
      ),
    );
  }
}

class _FollowButton extends ConsumerWidget {
  const _FollowButton({
    required this.user,
    required this.following,
    required this.notifier,
  });

  final UserData user;
  final bool following;
  final UserConnectionsNotifier notifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final padding = ref.watch(displayPreferencesProvider).edgeInsets;
    final theme = Theme.of(context);

    return HarpyButton.text(
      padding: padding,
      label: following
          ? const Text('following')
          : Text(
              'follow',
              style: TextStyle(color: theme.colorScheme.onBackground),
            ),
      onTap: () {
        HapticFeedback.lightImpact();
        if (following) {
          notifier.unfollow(user.id);
        } else {
          notifier.follow(user.id);
        }
      },
    );
  }
}
