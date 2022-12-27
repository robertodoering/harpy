import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/components/pages/user/widgets/user_page_connections.dart';
import 'package:harpy/components/pages/user/widgets/user_page_description_translation.dart';
import 'package:harpy/components/pages/user/widgets/user_page_info.dart';
import 'package:harpy/components/pages/user/widgets/user_page_metadata.dart';
import 'package:rby/rby.dart';

class UserPageHeader extends StatelessWidget {
  const UserPageHeader({
    required this.data,
    required this.notifier,
    required this.isAuthenticatedUser,
  });

  final UserPageData data;
  final UserPageNotifier notifier;
  final bool isAuthenticatedUser;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverToBoxAdapter(
      child: Card(
        margin: theme.spacing.edgeInsets.copyWith(bottom: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserPageInfo(
              data: data,
              notifier: notifier,
              isAuthenticatedUser: isAuthenticatedUser,
            ),
            if (data.user.description != null) ...[
              VerticalSpacer.small,
              Padding(
                padding: theme.spacing.symmetric(horizontal: true),
                child: TwitterText(
                  data.user.description!,
                  entities: data.user.descriptionEntities,
                ),
              ),
              Padding(
                padding: theme.spacing.symmetric(horizontal: true),
                child: UserPageDescriptionTranslation(data: data),
              ),
            ],
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: theme.spacing.only(start: true),
                    child: UserPageMetadata(data: data),
                  ),
                ),
                if (data.user.description != null)
                  UserPageDescriptionTranslationButton(
                    data: data,
                    notifier: notifier,
                  ),
              ],
            ),
            UserPageConnections(
              user: data.user,
              relationship: data.relationship,
              isAuthenticatedUser: isAuthenticatedUser,
            ),
          ],
        ),
      ),
    );
  }
}
