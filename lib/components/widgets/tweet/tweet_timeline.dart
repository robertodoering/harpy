import 'package:flutter/material.dart';
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

  /// Listens to the [ScrollController] and calls [TimelineModel.requestMore]
  /// when the bottom of the list has been reached.
  void _scrollListener() {
    if (_timelineModel != null) {
      // if the list is scrolled to the bottom request more
      if (!_timelineModel.requestingMore &&
          _scrollController.position.extentAfter < 150.0) {
        _timelineModel.requestMore();
      }
    }
  }

  /// Builds a placeholder widget when no tweets exist or when currently loading
  /// tweets.
  Widget _buildPlaceholder() {
    if (_timelineModel.tweets.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: _timelineModel.loadingInitialTweets
              ? const CircularProgressIndicator()
              : const Text("No tweets exist"),
        ),
      );
    } else {
      return null;
    }
  }

  /// Builds a widget at the end of the list for loading more tweets.
  Widget _buildsTrailing() {
    if (_timelineModel.requestingMore) {
      return SizedBox(
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("Loading more tweets..."),
            const SizedBox(height: 16),
            const CircularProgressIndicator(),
          ],
        ),
      );
    } else {
      return null;
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

    _scrollController = (inherited ?? ScrollController())
      ..addListener(_scrollListener);

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
            leading: widget.leading,
            placeHolder: _buildPlaceholder(),
            trailing: _buildsTrailing(),
          ),
        );
      },
    );
  }
}
