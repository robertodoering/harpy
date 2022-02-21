import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';

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
          ? () => notifier.load(clearPrevious: true)
          : null,
    );
  }
}

class _ComposeButton extends ConsumerWidget {
  const _ComposeButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeTimelineProvider);

    return HarpyButton.card(
      icon: const Icon(FeatherIcons.feather),
      onTap: state.tweets.isNotEmpty
          ? () {} // TODO: navigate to compose page
          : null,
    );
  }
}

class _FilterButton extends ConsumerWidget {
  const _FilterButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeTimelineProvider);

    return HarpyButton.card(
      icon: const Icon(Icons.filter_alt_outlined),
      onTap: state.tweets.isNotEmpty
          ? () {} // TODO: navigate to filter page
          : null,
    );
  }
}
