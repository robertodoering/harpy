import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';

class UserCard extends StatelessWidget {
  const UserCard(this.user);

  final UserData user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        borderRadius: theme.shape.borderRadius,
        onTap: () => context.pushNamed(
          UserPage.name,
          params: {'handle': user.handle},
          extra: user,
        ),
        child: Column(
          children: [
            RbyListTile(
              color: theme.cardTheme.color,
              verticalAlignment: CrossAxisAlignment.start,
              contentPadding: theme.spacing.edgeInsets.copyWith(
                bottom: theme.spacing.small,
              ),
              leadingPadding: theme.spacing.edgeInsets.copyWith(
                bottom: theme.spacing.small,
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
                    textDirection: TextDirection.ltr,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                  ),
                  if (user.hasDescription) ...[
                    VerticalSpacer.small,
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
