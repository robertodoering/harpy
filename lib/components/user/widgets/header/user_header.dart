import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';

class UserHeader extends StatelessWidget {
  const UserHeader({
    required this.user,
    required this.notifier,
    required this.connections,
    required this.connectionsNotifier,
  });

  final UserData user;
  final UserNotifier notifier;
  final BuiltSet<UserConnection>? connections;
  final UserConnectionsNotifier connectionsNotifier;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverToBoxAdapter(
      child: Card(
        margin: theme.spacing.edgeInsets.copyWith(bottom: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserInfo(
              user: user,
              connections: connections,
              connectionsNotifier: connectionsNotifier,
            ),
            if (user.hasDescription) ...[
              Padding(
                padding: theme.spacing.symmetric(horizontal: true),
                child: TwitterText(
                  user.description!,
                  entities: user.userDescriptionEntities,
                ),
              ),
              Padding(
                padding: theme.spacing.symmetric(horizontal: true),
                child: UserDescriptionTranslation(user: user),
              ),
              VerticalSpacer.small,
            ],
            AnimatedSize(
              duration: theme.animation.short,
              curve: Curves.easeOutCubic,
              alignment: AlignmentDirectional.topCenter,
              child: Padding(
                padding: theme.spacing.symmetric(horizontal: true),
                child: UserAdditionalInfo(user: user, connections: connections),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(child: UserConnectionsCount(user: user)),
                if (user.hasDescription)
                  UserDescriptionTranslationButton(
                    user: user,
                    notifier: notifier,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
