import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/components/widgets/shared/animations.dart';
import 'package:harpy/components/widgets/tweet/tweet_tile.dart';
import 'package:harpy/models/timeline_model.dart';
import 'package:logging/logging.dart';
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

  /// Listens to the [ScrollController] and calls [TimelineModel.requestMore]
  /// when the bottom of the list has been reached.
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

  /// Called whenever the list rebuilds with a list of the currently visible
  /// [Tweet]s in the list.
  void _onVisibleTweetsChange(List<Tweet> visibleTweets) {
    _timelineModel.visibleTweets = visibleTweets;
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
      content.add(_buildListPlaceholder());
    }
    if (_timelineModel.requestingMore) {
      content.add(_buildRequestingMore());
    } else if (_timelineModel.blockRequestingMore) {
      content.add(_buildRequestingMoreBlocked());
    }

    return SlideFadeInAnimation(
      offset: const Offset(0.0, 100.0),
      child: CustomTweetListView(
        controller: _controller,
        content: content,
//        onVisibleTweetsChange: _onVisibleTweetsChange, // todo: not needed
      ),
    );
  }

  /// Builds a placeholder widget when no tweets exist or when currently loading
  /// tweets.
  Widget _buildListPlaceholder() {
    Widget child;

    if (_timelineModel.loadingInitialTweets) {
      child = CircularProgressIndicator();
    } else {
      child = Text("No tweets exist");
    }

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Center(child: child),
    );
  }

  /// Builds a widget that is added to the end of the list content while more
  /// tweets are currently requested.
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
      child: Center(
        child: Text("Please wait a bit before loading more tweets"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _initScrollController();

    return ScopedModelDescendant<T>(
      builder: (context, oldChild, T timelineModel) {
        _timelineModel = timelineModel;

        return RefreshIndicator(
          onRefresh: timelineModel.updateTweets,
          child: _buildList(),
        );
      },
    );
  }
}

/// The callback when the currently displayed tweets in the list change.
typedef void OnVisibleTweetsChange(List<Tweet> tweets);

/// Wraps a [ListView.custom] to build a custom [ListView] for the [TweetList].
class CustomTweetListView extends StatelessWidget {
  const CustomTweetListView({
    this.controller,
    @required this.content,
    this.onVisibleTweetsChange,
  });

  /// The [ScrollController] that might be inherited.
  final ScrollController controller;

  /// The tweet list content containing [Widget]s and [Tweet]s which are used to
  /// build [TweetTile]s.
  final List content;

  /// Called whenever the currently displayed tweets in the list change.
  final OnVisibleTweetsChange onVisibleTweetsChange;

  static final Logger _log = Logger("CustomTweetListView");

  Widget _itemBuilder(BuildContext context, int index) {
    if (content[index] is Tweet) {
      Tweet tweet = content[index];

      return TweetTile(
        key: Key(tweet.idStr),
        tweet: tweet,
      );
    } else {
      return content[index];
    }
  }

  Widget _separatorBuilder(BuildContext context, int index) {
    return Divider(height: 0.0);
  }

  /// Calls [_itemBuilder] or [_separatorBuilder] depending on the current
  /// index.
  Widget _childrenBuilder(BuildContext context, int index) {
    final int itemIndex = index ~/ 2;

    return index.isEven
        ? _itemBuilder(context, itemIndex)
        : _separatorBuilder(context, itemIndex);
  }

  /// Called whenever the list rebuilds with the first and last index being the
  /// visible items.
  void _onLayoutFinish(int firstIndex, int lastIndex) {
    final int first = firstIndex ~/ 2;
    final int last = lastIndex ~/ 2;

    try {
      if (onVisibleTweetsChange != null) {
        List<Tweet> tweets =
            content.sublist(first, last).whereType<Tweet>().toList();

        onVisibleTweetsChange(tweets);
      }
    } catch (e) {
      _log.severe(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final childCount = content.length * 2 - 1;

    SliverChildDelegate childrenDelegate = CustomSliverChildBuilderDelegate(
      _childrenBuilder,
      itemCount: childCount,
      onLayoutFinish: _onLayoutFinish,
    );

    return ListView.custom(
      controller: controller,
      padding: EdgeInsets.zero,
      childrenDelegate: childrenDelegate,
      semanticChildCount: childCount,
    );
  }
}

/// Called at the end of layout to indicate that layout is now complete.
typedef void OnLayoutFinish(int firstIndex, int lastIndex);

class CustomSliverChildBuilderDelegate extends SliverChildBuilderDelegate {
  const CustomSliverChildBuilderDelegate(
    IndexedWidgetBuilder builder, {
    @required int itemCount,
    this.onLayoutFinish,
  }) : super(
          builder,
          childCount: itemCount,
          addAutomaticKeepAlives: false,
        );

  final OnLayoutFinish onLayoutFinish;

  // todo: override estimated size algorithm for a better scrollbar

  @override
  void didFinishLayout(int firstIndex, int lastIndex) {
    if (onLayoutFinish != null) {
      onLayoutFinish(firstIndex, lastIndex);
    }
  }
}
