import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';

class LegacyUserHeader extends StatelessWidget {
  const LegacyUserHeader({
    required this.user,
    required this.notifier,
    required this.connections,
    required this.connectionsNotifier,
  });

  final LegacyUserData user;
  final LegacyUserNotifier notifier;
  final BuiltSet<LegacyUserConnection>? connections;
  final LegacyUserConnectionsNotifier connectionsNotifier;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverToBoxAdapter(
      child: Card(
        margin: theme.spacing.edgeInsets.copyWith(bottom: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LegacyUserInfo(
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
                child: LegacyUserDescriptionTranslation(user: user),
              ),
              VerticalSpacer.small,
            ],
            AnimatedSize(
              duration: theme.animation.short,
              curve: Curves.easeOutCubic,
              alignment: AlignmentDirectional.topCenter,
              child: Padding(
                padding: theme.spacing.symmetric(horizontal: true),
                child: LegacyUserAdditionalInfo(
                  user: user,
                  connections: connections,
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(child: LegacyUserConnectionsCount(user: user)),
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
