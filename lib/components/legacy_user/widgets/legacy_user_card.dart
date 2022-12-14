import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';

class LegacyUserCard extends StatelessWidget {
  const LegacyUserCard(this.user);

  final UserData user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // TODO: show verified / protected icon next to name in user card
    // TODO: disable connections count if user is protected and not followed by
    //  the authenticated user

    return Card(
      child: InkWell(
        borderRadius: theme.shape.borderRadius,
        onTap: () => context.pushNamed(
          UserPage.name,
          params: {'handle': user.handle},
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
              leading: user.profileImage?.normal != null
                  ? HarpyCircleAvatar(
                      imageUrl: user.profileImage!.normal!.toString(),
                    )
                  : null,
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
                  if (user.description != null) ...[
                    VerticalSpacer.small,
                    TwitterText(
                      user.description!,
                      entities: user.descriptionEntities,
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
              child: LegacyUserConnectionsCount(user: user, compact: true),
            ),
          ],
        ),
      ),
    );
  }
}
