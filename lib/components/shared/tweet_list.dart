import 'package:flutter/material.dart';
import 'package:flutter_flux/flutter_flux.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/components/shared/animations.dart';
import 'package:harpy/components/shared/tweet_tile.dart';

// todo:
// to animate new tweets in after a refresh:
// maybe have 2 list of tweets,
// wrap the new tweets into a single widget / into a list view
// set the initial index of the main list view to the old tweets
// scroll up

// maybe stay on the old index and scroll up when rebuilding

/// A list containing many [TweetTile]s.
class TweetList extends StatefulWidget {
  /// The [Tweet]s that build into [TweetTile]s.
  final List<Tweet> tweets;

  /// The [leading] widget will be shown at the top of the list before the
  /// [tweets].
  final Widget leading;

  /// The [trailing] widget will be shown at the end of the list after the
  /// [tweets].
  final Widget trailing;

  /// The callback of the [RefreshIndicator] of the list.
  ///
  /// If [onRefresh] is `null`, no [RefreshIndicator] will be shown.
  final RefreshCallback onRefresh;

  /// A method called when reaching the end of the list.
  final Function onRequestMore;

  /// The [type] of this list.
  final ListType type;

  const TweetList({
    this.tweets,
    this.leading,
    this.trailing,
    this.onRefresh,
    this.onRequestMore,
    this.type,
  });

  @override
  _TweetListState createState() => _TweetListState();
}

class _TweetListState extends State<TweetList> with StoreWatcherMixin {
  ScrollController _controller;

  bool _requestingMore = false;

  @override
  void initState() {
    super.initState();

    // todo: (low priority) fix: _controller needs to be null to work with SliverAppBar in user profile screen.
    if (widget.onRequestMore != null) {
      _controller = ScrollController()..addListener(_scrollListener);
    }
  }

  void _scrollListener() {
    if (widget.onRequestMore != null &&
        _controller.position.extentAfter < 500.0 &&
        !_requestingMore) {
      setState(() {
        _requestingMore = true;

        widget.onRequestMore().then((_) {
          setState(() {
            _requestingMore = false;
          });
        });
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InheritedTweetList(
      type: widget.type,
      child: widget.onRefresh != null
          ? RefreshIndicator(
              onRefresh: widget.onRefresh,
              child: _buildList(),
            )
          : _buildList(),
    );
  }

  Widget _buildList() {
    List content = [];
    if (widget.leading != null) content.add(widget.leading);
    if (widget.tweets != null) content.addAll(widget.tweets);
    if (widget.trailing != null) content.add(widget.trailing);

    return SlideFadeInAnimation(
      offset: const Offset(0.0, 100.0),
      child: ListView.separated(
        padding: EdgeInsets.zero,
        controller: _controller,
        itemCount: content.length,
        itemBuilder: (context, index) {
          if (content[index] is Tweet) {
            Tweet tweet = content[index];

            return TweetTile(
              key: Key("${tweet.id}"),
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
}

/// The [ListType] defines types that the list is used for.
///
/// (home timeline / user timeline)
enum ListType {
  home,
  user,
}

/// The [InheritedTweetList] contains data for children to access.
class InheritedTweetList extends InheritedWidget {
  final ListType type;

  const InheritedTweetList({
    this.type,
    Widget child,
  }) : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }

  static InheritedTweetList of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(InheritedTweetList);
  }
}
