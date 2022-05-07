import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

class UserCard extends ConsumerWidget {
  const UserCard(this.user);

  final UserData user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final harpyTheme = ref.watch(harpyThemeProvider);
    final display = ref.watch(displayPreferencesProvider);
    final router = ref.watch(routerProvider);

    return Card(
      child: InkWell(
        borderRadius: harpyTheme.borderRadius,
        onTap: () => router.pushNamed(
          UserPage.name,
          params: {'handle': user.handle},
          extra: user,
        ),
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
              child: UserConnectionsCount(user: user, compact: true),
            ),
          ],
        ),
      ),
    );
  }
}
