import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:provider/provider.dart';

class MentionsTimeline extends StatefulWidget {
  const MentionsTimeline({
    required this.indexInTabView,
  });

  final int indexInTabView;

  @override
  _MentionsTimelineState createState() => _MentionsTimelineState();
}

class _MentionsTimelineState extends State<MentionsTimeline> {
  late TabController _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _controller = DefaultTabController.of(context)!..addListener(_listener);
  }

  @override
  void dispose() {
    super.dispose();

    _controller.removeListener(_listener);
  }

  void _listener() {
    if (mounted && _controller.index == widget.indexInTabView) {
      context.read<MentionsTimelineBloc>().add(const UpdateViewedMentions());
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final bloc = context.watch<MentionsTimelineBloc>();
    final state = bloc.state;

    return ScrollToStart(
      child: TweetList(
        state.timelineTweets,
        key: const PageStorageKey<String>('mentions_timeline'),
        endSlivers: <Widget>[
          if (state.showLoading)
            const TweetListLoadingSliver()
          else if (state.showNoMentionsFound)
            const SliverFillLoadingError(
              message: Text('no mentions found'),
            )
          else if (state.showMentionsError)
            SliverFillLoadingError(
              message: const Text('error loading mentions'),
              onRetry: () => bloc.add(const RequestMentionsTimeline(
                updateViewedMention: true,
              )),
            ),
          SliverToBoxAdapter(
            child: SizedBox(height: mediaQuery.padding.bottom),
          ),
        ],
      ),
    );
  }
}
