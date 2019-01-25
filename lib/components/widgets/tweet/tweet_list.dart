import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/components/widgets/shared/animations.dart';
import 'package:harpy/components/widgets/tweet/tweet_tile.dart';
import 'package:harpy/models/timeline_model.dart';
import 'package:scoped_model/scoped_model.dart';

/// The list of [TweetTile] for a [TimelineModel].
///
/// If [leading] is not `null` it will be placed at the start of the list.
class TweetList<T extends TimelineModel> extends StatefulWidget {
  const TweetList({
    this.leading,
  });

  /// The first [Widget] in the [ListView] if not `null`.
  final Widget leading;

  @override
  TweetListState createState() => TweetListState<T>();
}

class TweetListState<T extends TimelineModel> extends State<TweetList> {
  ScrollController _controller;
  bool _disposeController = false;

  TimelineModel _timelineModel;

  /// Initializes the [_controller] if it hasn't been initialized yet.
  ///
  /// Can't be in [initState] because we get an inherited
  /// [PrimaryScrollController] if it exists.
  void _initScrollController() {
    if (_controller == null) {
      ScrollController inherited = PrimaryScrollController.of(context);
      _controller = inherited ?? ScrollController();
      _controller.addListener(_scrollListener);

      // dispose the controller if it hasn't been inherited
      // it gets inherited by the FadingNestedScaffold in the user profile
      // screen
      _disposeController = inherited == null;
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (_disposeController) {
      _controller.dispose();
    }
  }

  void _scrollListener() {
    if (_timelineModel != null) {
      // if the list is scrolled to the bottom request more
      if (!_timelineModel.requestingMore &&
          !_timelineModel.blockRequestingMore &&
          _controller.position.extentAfter < 150.0) {
        _timelineModel.requestMore();
      }
    }
  }

  /// Adds the content for the [ListView].
  ///
  /// [TweetTile]s are build from the [tweets].
  /// If no [tweets] exist a [CircularProgressIndicator] is built instead while
  /// the [TimelineModel] is loading [Tweet]s.
  ///
  /// If no [tweets] exist and the [TimelineModel] is not loading a message is
  /// built.
  Widget _buildList() {
    List content = [];
    if (widget.leading != null) {
      content.add(widget.leading);
    }
    if (_timelineModel.tweets.isNotEmpty) {
      content.addAll(_timelineModel.tweets);
    } else {
      content.add(_addListPlaceholder());
    }
    if (_timelineModel.requestingMore) {
      content.add(_buildRequestingMore());
    } else if (_timelineModel.blockRequestingMore) {
      content.add(_buildRequestingMoreBlocked());
    }

    return SlideFadeInAnimation(
      offset: const Offset(0.0, 100.0),
      child: ListView.separated(
        controller: _controller,
        padding: EdgeInsets.zero,
        itemCount: content.length,
        itemBuilder: (context, index) {
          if (content[index] is Tweet) {
            Tweet tweet = content[index];

            return TweetTile(
              key: Key(tweet.idStr),
              tweet: tweet,
            );
          } else {
            return content[index];
          }
        },
        separatorBuilder: (context, index) => Divider(height: 0.0),
      ),
    );
  }

  Widget _addListPlaceholder() {
    if (_timelineModel.loadingInitialTweets) {
      return Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(child: CircularProgressIndicator()),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(child: Text("No tweets exist")), // todo: i18n
      );
    }
  }

  Widget _buildRequestingMore() {
    return SizedBox(
      height: 100.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Loading more tweets..."),
          SizedBox(height: 16.0),
          CircularProgressIndicator(),
        ],
      ),
    );
  }

  Widget _buildRequestingMoreBlocked() {
    return SizedBox(
      height: 100.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Please wait a bit before loading more tweets"),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _initScrollController();

    return ScopedModelDescendant<T>(
      builder: (context, oldChild, TimelineModel timelineModel) {
        _timelineModel = timelineModel;

        return RefreshIndicator(
          onRefresh: timelineModel.updateTweets,
          child: _buildList(),
        );
      },
    );
  }
}
