import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';

class MentionsTimelineTopActions extends ConsumerWidget {
  const MentionsTimelineTopActions();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.read(mentionsTimelineProvider);
    final notifier = ref.read(mentionsTimelineProvider.notifier);

    return SliverToBoxAdapter(
      child: Padding(
        padding: theme.spacing.edgeInsets.copyWith(bottom: 0),
        child: Row(
          children: [
            RbyButton.card(
              icon: const Icon(CupertinoIcons.refresh),
              onTap: state.tweets.isNotEmpty
                  ? () {
                      HapticFeedback.lightImpact();
                      UserScrollDirection.of(context)?.idle();
                      notifier.load(clearPrevious: true);
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
