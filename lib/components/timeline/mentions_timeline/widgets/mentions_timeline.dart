import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';

class MentionsTimeline extends ConsumerStatefulWidget {
  const MentionsTimeline({
    this.beginSlivers = const [],
    this.endSlivers = const [SliverBottomPadding()],
    this.refreshIndicatorOffset,
    this.scrollToTopOffset,
  });

  final List<Widget> beginSlivers;
  final List<Widget> endSlivers;
  final double? refreshIndicatorOffset;
  final double? scrollToTopOffset;

  @override
  ConsumerState<MentionsTimeline> createState() => _MentionsTimelineState();
}

class _MentionsTimelineState extends ConsumerState<MentionsTimeline> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      ref.read(mentionsTimelineProvider.notifier).updateViewedMentions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Timeline(
      provider: mentionsTimelineProvider,
      refreshIndicatorOffset: widget.refreshIndicatorOffset,
      scrollToTopOffset: widget.scrollToTopOffset,
      beginSlivers: [
        ...widget.beginSlivers,
        const _TopActions(),
      ],
      endSlivers: widget.endSlivers,
    );
  }
}

class _TopActions extends ConsumerWidget {
  const _TopActions();

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
