import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

class HomeTimelineTopActions extends ConsumerWidget {
  const HomeTimelineTopActions();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(displayPreferencesProvider);

    return SliverToBoxAdapter(
      child: Padding(
        padding: display.edgeInsets.copyWith(bottom: 0),
        child: Row(
          children: const [
            _RefreshButton(),
            Spacer(),
            _ComposeButton(),
            horizontalSpacer,
            _FilterButton(),
          ],
        ),
      ),
    );
  }
}

class _RefreshButton extends ConsumerWidget {
  const _RefreshButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeTimelineProvider);
    final notifier = ref.watch(homeTimelineProvider.notifier);

    return HarpyButton.card(
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

class _ComposeButton extends ConsumerWidget {
  const _ComposeButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final state = ref.watch(homeTimelineProvider);

    return HarpyButton.card(
      icon: const Icon(FeatherIcons.feather),
      onTap: state is! TimelineStateLoading
          ? () => router.goNamed(ComposePage.name)
          : null,
    );
  }
}

class _FilterButton extends ConsumerWidget {
  const _FilterButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final router = ref.watch(routerProvider);
    final state = ref.watch(homeTimelineProvider);
    final notifier = ref.watch(homeTimelineProvider.notifier);

    final enable = state is! TimelineStateLoading;

    return HarpyButton.card(
      icon: notifier.filter != null
          ? Icon(
              Icons.filter_alt,
              color: enable
                  ? theme.colorScheme.primary
                  : theme.colorScheme.primary.withOpacity(.5),
            )
          : const Icon(Icons.filter_alt_outlined),
      onTap: enable ? () => router.pushNamed(HomeTimelineFilter.name) : null,
    );
  }
}
