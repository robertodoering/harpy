import 'package:flutter/cupertino.dart';
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mentionsTimelineProvider.notifier).updateViewedMentions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Timeline(
      provider: mentionsTimelineProvider,
      listKey: const PageStorageKey('mentions_timeline'),
      refreshIndicatorOffset: widget.refreshIndicatorOffset,
      scrollToTopOffset: widget.scrollToTopOffset,
      beginSlivers: [
        ...widget.beginSlivers,
        const MentionsTimelineTopActions(),
      ],
      endSlivers: widget.endSlivers,
    );
  }
}
