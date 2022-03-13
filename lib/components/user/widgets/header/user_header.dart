import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

class UserHeader extends ConsumerWidget {
  const UserHeader({
    required this.user,
  });

  final UserData user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(displayPreferencesProvider);

    return SliverToBoxAdapter(
      child: Card(
        margin: display.edgeInsets.copyWith(bottom: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserInfo(user: user),
            if (user.hasDescription) ...[
              Padding(
                padding: display.edgeInsetsSymmetric(horizontal: true),
                child: TwitterText(
                  user.description!,
                  entities: user.userDescriptionEntities,
                ),
              ),
              Padding(
                padding: display.edgeInsetsSymmetric(horizontal: true),
                child: UserDescriptionTranslation(user: user),
              ),
              smallVerticalSpacer,
            ],
            Padding(
              padding: display.edgeInsetsOnly(left: true),
              child: UserAdditionalInfo(user: user),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(child: UserConnectionsCount(user: user)),
                if (user.hasDescription)
                  UserDescriptionTranslationButton(user: user),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
