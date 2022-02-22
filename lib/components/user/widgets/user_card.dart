import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/rby/rby.dart';
import 'package:intl/intl.dart';

class UserCard extends ConsumerWidget {
  const UserCard(this.user);

  final UserData user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final harpyTheme = ref.watch(harpyThemeProvider);
    final display = ref.watch(displayPreferencesProvider);
    final router = ref.watch(routerProvider);

    return VisibilityChangeListener(
      detectorKey: ValueKey(user.hashCode),
      child: ListCardAnimation(
        child: Card(
          child: InkWell(
            borderRadius: harpyTheme.borderRadius,
            // TODO: provide initial user
            onTap: () => router.goNamed(UserPage.name),
            child: Column(
              children: [
                HarpyListTile(
                  color: theme.cardTheme.color,
                  verticalAlignment: CrossAxisAlignment.start,
                  contentPadding: display.edgeInsets.copyWith(
                    bottom: display.smallPaddingValue,
                  ),
                  leadingPadding: display.edgeInsets.copyWith(
                    bottom: display.smallPaddingValue,
                  ),
                  leading: HarpyCircleAvatar(
                    imageUrl: user.profileImageUrl,
                  ),
                  title: Text(
                    user.name,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '@${user.handle}',
                        softWrap: false,
                        overflow: TextOverflow.fade,
                      ),
                      if (user.hasDescription) ...[
                        smallVerticalSpacer,
                        TwitterText(
                          user.description!,
                          entities: user.userDescriptionEntities,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          entityStyle: const TextStyle(),
                          onHashtagTap: null,
                          onUserMentionTap: null,
                          onUrlTap: null,
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: _ConnectionsCount(user: user),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ConnectionsCount extends ConsumerWidget {
  const _ConnectionsCount({
    required this.user,
  });

  final UserData user;

  static final _numberFormat = NumberFormat.compact();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(displayPreferencesProvider);
    final router = ref.watch(routerProvider);

    final friendsCount = _numberFormat.format(user.friendsCount);
    final followersCount = _numberFormat.format(user.followersCount);

    return Wrap(
      children: [
        Tooltip(
          message: '${user.friendsCount}',
          child: HarpyButton.icon(
            label: Text('$friendsCount following'),
            padding: EdgeInsets.symmetric(
              horizontal: display.paddingValue,
              vertical: display.smallPaddingValue,
            ),
            onTap: () => router.pushNamed(
              FollowingPage.name,
              params: {'id': user.id},
            ),
          ),
        ),
        horizontalSpacer,
        Tooltip(
          message: '${user.followersCount}',
          child: HarpyButton.icon(
            label: Text('$followersCount followers'),
            padding: EdgeInsets.symmetric(
              horizontal: display.paddingValue,
              vertical: display.smallPaddingValue,
            ),
            onTap: () => router.pushNamed(
              FollowersPage.name,
              params: {'id': user.id},
            ),
          ),
        ),
      ],
    );
  }
}
