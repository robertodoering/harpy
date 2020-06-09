import 'package:flutter/material.dart';
import 'package:harpy/components/widgets/shared/loading_tile.dart';
import 'package:harpy/components/widgets/tweet/tweet_list.dart';
import 'package:harpy/models/timeline_model.dart';
import 'package:provider/provider.dart';

/// Builds a [TweetList] for a [TimelineModel].
class TweetTimeline<T extends TimelineModel> extends StatefulWidget {
  const TweetTimeline({
    this.leading,
  });

  final Widget leading;

  @override
  _TweetTimelineState createState() => _TweetTimelineState<T>();
}

class _TweetTimelineState<T extends TimelineModel>
    extends State<TweetTimeline> {
  ScrollController _scrollController;
  bool _disposeController = false;

  TimelineModel _timelineModel;

  /// Builds a placeholder widget when no tweets exist or when currently loading
  /// tweets.
  Widget _buildPlaceholder() {
    if (_timelineModel.loadingInitialTweets) {
      return const LoadingTweetTile();
    } else {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(
          child: Text("No tweets found"),
        ),
      );
    }
  }

  void _onTweetsUpdated() {
    if (_scrollController != null && _scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final ScrollController inherited = PrimaryScrollController.of(context);

    _scrollController = inherited ?? ScrollController();

    // dispose the controller if it hasn't been inherited
    // it gets inherited by the FadingNestedScaffold in the user profile
    // screen
    _disposeController = inherited == null;
  }

  @override
  void dispose() {
    super.dispose();
    if (_disposeController) {
      _scrollController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<T>(
      builder: (context, model, _) {
        _timelineModel = model..onTweetsUpdated = _onTweetsUpdated;

        return RefreshIndicator(
          onRefresh: model.updateTweets,
          child: TweetList(
            tweets: model.tweets,
            scrollController: _scrollController,
            onLoadMore: _timelineModel.requestMore,
            enableLoadMore: _timelineModel.enableRequestingMore,
            leading: widget.leading,
            placeHolder: _buildPlaceholder(),
          ),
        );
      },
    );
  }
}
