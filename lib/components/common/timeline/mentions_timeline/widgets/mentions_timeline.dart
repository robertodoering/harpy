import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

class MentionsTimeline extends StatefulWidget {
  const MentionsTimeline({
    required this.indexInTabView,
    this.beginSlivers = const [],
    this.endSlivers = const [SliverBottomPadding()],
    this.refreshIndicatorOffset,
  });

  final int indexInTabView;
  final List<Widget> beginSlivers;
  final List<Widget> endSlivers;
  final double? refreshIndicatorOffset;

  @override
  _MentionsTimelineState createState() => _MentionsTimelineState();
}

class _MentionsTimelineState extends State<MentionsTimeline> {
  TabController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller ??= DefaultTabController.of(context)?..addListener(_listener);

    assert(_controller != null);
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.removeListener(_listener);
  }

  void _listener() {
    if (mounted && _controller?.index == widget.indexInTabView) {
      context.read<MentionsTimelineCubit>().updateViewedMentions();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<MentionsTimelineCubit>();

    return BlocProvider<TimelineCubit>.value(
      value: cubit,
      child: Timeline(
        listKey: const PageStorageKey('mentions_timeline'),
        refreshIndicatorOffset: widget.refreshIndicatorOffset,
        beginSlivers: [
          ...widget.beginSlivers,
          const _TopRow(),
        ],
        endSlivers: widget.endSlivers,
      ),
    );
  }
}

class _TopRow extends StatelessWidget {
  const _TopRow();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = context.watch<ConfigCubit>().state;
    final cubit = context.watch<MentionsTimelineCubit>();
    final state = cubit.state;

    return SliverToBoxAdapter(
      child: Padding(
        padding: config.edgeInsetsOnly(
          top: true,
          left: true,
          right: true,
        ),
        child: Row(
          children: [
            HarpyButton.raised(
              padding: config.edgeInsets,
              elevation: 0,
              backgroundColor: theme.cardTheme.color,
              icon: const Icon(CupertinoIcons.refresh),
              onTap: state.hasTweets
                  ? () => cubit.load(clearPrevious: true)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
