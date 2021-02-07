import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:harpy/components/common/dialogs/changelog_dialog.dart';
import 'package:harpy/components/common/dialogs/harpy_exit_dialog.dart';
import 'package:harpy/components/common/list/scroll_direction_listener.dart';
import 'package:harpy/components/common/list/scroll_to_start.dart';
import 'package:harpy/components/common/list/slivers/sliver_fill_loading_error.dart';
import 'package:harpy/components/common/list/slivers/sliver_fill_loading_indicator.dart';
import 'package:harpy/components/common/misc/harpy_scaffold.dart';
import 'package:harpy/components/compose/widget/compose_screen.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';
import 'package:harpy/components/timeline/new/home_timeline/bloc/home_timeline_bloc.dart';
import 'package:harpy/components/tweet/widgets/tweet_list.dart';
import 'package:harpy/core/api/twitter/tweet_data.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/misc/harpy_navigator.dart';

import 'content/home_app_bar.dart';
import 'content/home_drawer.dart';
import 'content/new_tweets_text.dart';

/// The home screen for an authenticated user.
class HomeScreen extends StatefulWidget {
  const HomeScreen({
    this.autoLogin = false,
  });

  /// Whether the user got automatically logged in when opening the app
  /// (previous session got restored).
  final bool autoLogin;

  static const String route = 'home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware {
  bool _showFab = true;

  @override
  void initState() {
    super.initState();

    if (widget.autoLogin == true) {
      ChangelogDialog.maybeShow(context);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    app<HarpyNavigator>().routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    super.dispose();
    app<HarpyNavigator>().routeObserver.unsubscribe(this);
  }

  @override
  void didPopNext() {
    // force a rebuild when the home screen shows again
    setState(() {});
  }

  void _onScrollDirectionChanged(VerticalDirection direction) {
    final bool show = direction != VerticalDirection.down;

    if (_showFab != show) {
      setState(() {
        _showFab = show;
      });
    }
  }

  Widget _buildFloatingActionButton() {
    if (_showFab) {
      return FloatingActionButton(
        onPressed: () => app<HarpyNavigator>().pushNamed(ComposeScreen.route),
        child: const Icon(FeatherIcons.feather, size: 28),
      );
    } else {
      return null;
    }
  }

  Future<bool> _showExitDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) => const HarpyExitDialog(),
    ).then((bool pop) => pop == true);
  }

  Future<bool> _onWillPop(BuildContext context) async {
    // If the current pop request will close the application
    if (!Navigator.of(context).canPop()) {
      return _showExitDialog(context);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return ScrollDirectionListener(
      onScrollDirectionChanged: _onScrollDirectionChanged,
      child: WillPopScope(
        onWillPop: () => _onWillPop(context),
        child: HarpyScaffold(
          drawer: const HomeDrawer(),
          floatingActionButton: _buildFloatingActionButton(),
          body: BlocProvider<NewHomeTimelineBloc>(
            lazy: false,
            create: (_) => NewHomeTimelineBloc(),
            child: const HomeTimeline(),
            // child: BlocProvider<HomeTimelineBloc>(
            //   create: (BuildContext context) => HomeTimelineBloc(),
            //   child: TweetTimeline<HomeTimelineBloc>(
            //     headerSlivers: <Widget>[
            //       HarpySliverAppBar(
            //         title: 'Harpy',
            //         showIcon: true,
            //         floating: true,
            //         actions: _buildActions(),
            //       ),
            //     ],
            //     refreshIndicatorDisplacement: 80,
            //     onRefresh: (HomeTimelineBloc bloc) {
            //       bloc.add(const UpdateHomeTimelineEvent());
            //       return bloc.updateTimelineCompleter.future;
            //     },
            //     onLoadMore: (HomeTimelineBloc bloc) {
            //       bloc.add(const RequestMoreHomeTimelineEvent());
            //       return bloc.requestMoreCompleter.future;
            //     },
            //   ),
            // ),
          ),
        ),
      ),
    );
  }
}

class HomeTimeline extends StatefulWidget {
  const HomeTimeline();

  @override
  _HomeTimelineState createState() => _HomeTimelineState();
}

class _HomeTimelineState extends State<HomeTimeline> {
  ScrollController _controller;

  @override
  void initState() {
    super.initState();

    _controller = ScrollController();
  }

  void _blocListener(BuildContext context, HomeTimelineState state) {
    if (state is HomeTimelineResult && state.initialResults) {
      // scroll to the end after the list has been built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.jumpTo(_controller.position.maxScrollExtent);
      });
    }
  }

  Widget _tweetBuilder(
    HomeTimelineState state,
    TweetData tweet,
  ) {
    if (state is HomeTimelineResult &&
        state.newTweetsExist &&
        state.lastInitialTweet == tweet.idStr) {
      final List<Widget> children = <Widget>[
        TweetList.defaultTweetBuilder(tweet),
        defaultVerticalSpacer,
        const NewTweetsText(),
      ];

      return Column(
        mainAxisSize: MainAxisSize.min,
        // build the new tweets text above the last visible tweet if it exist
        children: state.includesLastVisibleTweet
            ? children.reversed.toList()
            : children,
      );
    } else {
      return TweetList.defaultTweetBuilder(tweet);
    }
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final NewHomeTimelineBloc bloc = context.watch<NewHomeTimelineBloc>();
    final HomeTimelineState state = bloc.state;

    // todo: show text at the end of a timeline when no older tweets can be
    //  retrieved

    return BlocListener<NewHomeTimelineBloc, HomeTimelineState>(
      listener: _blocListener,
      child: ScrollDirectionListener(
        child: ScrollToStart(
          controller: _controller,
          child: RefreshIndicator(
            onRefresh: () async {},
            child: TweetList(
              state.timelineTweets,
              controller: _controller,
              tweetBuilder: (TweetData tweet) => _tweetBuilder(state, tweet),
              beginSlivers: const <Widget>[
                HomeAppBar(),
              ],
              endSlivers: <Widget>[
                if (state.showInitialLoading)
                  const SliverFillLoadingIndicator()
                else if (state.showNoTweetsFound)
                  SliverFillLoadingError(
                    message: const Text('no tweets found'),
                    onRetry: () => bloc.add(null),
                  )
                else if (state.showSearchError)
                  SliverFillLoadingError(
                    message: const Text('error loading tweets'),
                    onRetry: () => bloc.add(null),
                  ),
                SliverToBoxAdapter(
                  child: SizedBox(height: mediaQuery.padding.bottom),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
