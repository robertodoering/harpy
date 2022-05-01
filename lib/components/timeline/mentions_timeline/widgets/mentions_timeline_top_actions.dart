import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';

class MentionsTimelineTopActions extends ConsumerWidget {
  const MentionsTimelineTopActions();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(displayPreferencesProvider);
    final state = ref.read(mentionsTimelineProvider);
    final notifier = ref.read(mentionsTimelineProvider.notifier);

    return SliverToBoxAdapter(
      child: Padding(
        padding: display.edgeInsets.copyWith(bottom: 0),
        child: Row(
          children: [
            HarpyButton.card(
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
