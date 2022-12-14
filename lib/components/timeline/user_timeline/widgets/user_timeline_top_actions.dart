import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';

class UserTimelineTopActions extends StatelessWidget {
  const UserTimelineTopActions({
    required this.user,
  });

  final UserData user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverToBoxAdapter(
      child: Padding(
        padding: theme.spacing.edgeInsets.copyWith(bottom: 0),
        child: Row(
          children: [
            _RefreshButton(user: user),
            const Spacer(),
            _FilterButton(user: user),
          ],
        ),
      ),
    );
  }
}

class _RefreshButton extends ConsumerWidget {
  const _RefreshButton({
    required this.user,
  });

  final UserData user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userTimelineProvider(user.id));
    final notifier = ref.watch(userTimelineProvider(user.id).notifier);

    return RbyButton.card(
      icon: const Icon(CupertinoIcons.refresh),
      onTap: state.tweets.isNotEmpty
          ? () {
              HapticFeedback.lightImpact();
              UserScrollDirection.of(context)?.idle();
              notifier.load(clearPrevious: true);
            }
          : null,
    );
  }
}

class _FilterButton extends ConsumerWidget {
  const _FilterButton({
    required this.user,
  });

  final UserData user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(userTimelineProvider(user.id));
    final notifier = ref.watch(userTimelineProvider(user.id).notifier);

    final enable = state is! TimelineStateLoading;

    return RbyButton.card(
      icon: notifier.filter != null
          ? Icon(
              Icons.filter_alt,
              color: enable
                  ? theme.colorScheme.primary
                  : theme.colorScheme.primary.withOpacity(.5),
            )
          : const Icon(Icons.filter_alt_outlined),
      onTap: enable
          ? () => context.pushNamed(
                UserTimelineFilter.name,
                params: {'handle': user.handle},
                extra: user,
              )
          : null,
    );
  }
}
