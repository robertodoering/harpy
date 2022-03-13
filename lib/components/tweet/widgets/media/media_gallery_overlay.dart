import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

enum MediaOverlayActions {
  retweet,
  favorite,
  spacer,
  download,
  show,
  actionsButton,
}

const kDefaultOverlayActions = {
  MediaOverlayActions.retweet,
  MediaOverlayActions.favorite,
  MediaOverlayActions.spacer,
  MediaOverlayActions.download,
  MediaOverlayActions.actionsButton,
};

class MediaGalleryOverlay extends ConsumerStatefulWidget {
  const MediaGalleryOverlay({
    required this.provider,
    required this.delegates,
    required this.media,
    required this.child,
    this.actions = kDefaultOverlayActions,
  });

  final StateNotifierProvider<TweetNotifier, TweetData> provider;
  final MediaData media;
  final TweetDelegates delegates;
  final Widget child;
  final Set<MediaOverlayActions> actions;

  @override
  _MediaOverlayState createState() => _MediaOverlayState();
}

class _MediaOverlayState extends ConsumerState<MediaGalleryOverlay>
    with SingleTickerProviderStateMixin, RouteAware {
  late final AnimationController _controller;
  late final Animation<Offset> _topAnimation;
  late final Animation<Offset> _bottomAnimation;

  RouteObserver? _observer;

  final _childKey = GlobalKey();
  final _appBarKey = GlobalKey();
  final _actionsKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: kShortAnimationDuration,
    );

    _topAnimation = Tween(begin: const Offset(0, -1), end: Offset.zero)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_controller);

    _bottomAnimation = Tween(begin: const Offset(0, 1), end: Offset.zero)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_controller);

    _controller.forward();
  }

  @override
  void didPop() {
    _controller.reverse();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _observer ??= ref.read(routeObserver)
      ?..subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    _observer?.unsubscribe(this);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tweet = ref.watch(widget.provider);

    final overlap = tweet.mediaType != MediaType.video;

    final child = Center(
      key: _childKey,
      child: HarpyDismissible(
        onDismissed: Navigator.of(context).pop,
        child: widget.child,
      ),
    );

    final appBar = Align(
      key: _appBarKey,
      alignment: Alignment.topCenter,
      child: SlideTransition(
        position: _topAnimation,
        child: const _OverlayAppBar(),
      ),
    );

    final actions = Align(
      key: _actionsKey,
      alignment: Alignment.bottomCenter,
      child: SlideTransition(
        position: _bottomAnimation,
        child: _OverlayTweetActions(
          tweet: tweet,
          media: widget.media,
          delegates: widget.delegates,
          actions: widget.actions,
        ),
      ),
    );

    return Column(
      children: [
        if (!overlap) appBar,
        Expanded(
          child: Stack(
            children: [
              child,
              if (overlap) appBar,
              if (overlap) actions,
            ],
          ),
        ),
        if (!overlap) actions,
      ],
    );
  }
}

class _OverlayAppBar extends ConsumerWidget {
  const _OverlayAppBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaQuery = MediaQuery.of(context);
    final display = ref.watch(displayPreferencesProvider);

    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: IntrinsicHeight(
        child: Container(
          alignment: Alignment.centerLeft,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black87,
                Colors.transparent,
              ],
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: display.smallPaddingValue)
              .copyWith(
                  top: display.smallPaddingValue + mediaQuery.padding.top),
          child: HarpyButton.icon(
            icon: const Icon(CupertinoIcons.xmark, color: Colors.white),
            onTap: Navigator.of(context).maybePop,
          ),
        ),
      ),
    );
  }
}

class _OverlayTweetActions extends ConsumerWidget {
  const _OverlayTweetActions({
    required this.tweet,
    required this.media,
    required this.delegates,
    required this.actions,
  });

  final TweetData tweet;
  final MediaData media;
  final TweetDelegates delegates;
  final Set<MediaOverlayActions> actions;

  Widget _mapAction(
    BuildContext context,
    Reader read, {
    required MediaOverlayActions action,
  }) {
    switch (action) {
      case MediaOverlayActions.retweet:
        return RetweetButton(
          tweet: tweet,
          sizeDelta: 2,
          foregroundColor: Colors.white,
          onRetweet: delegates.onRetweet,
          onUnretweet: delegates.onUnretweet,
          onShowRetweeters: delegates.onShowRetweeters,
          onComposeQuote: delegates.onComposeQuote,
        );
      case MediaOverlayActions.favorite:
        return FavoriteButton(
          tweet: tweet,
          sizeDelta: 2,
          foregroundColor: Colors.white,
          onFavorite: delegates.onFavorite,
          onUnfavorite: delegates.onUnfavorite,
        );
      case MediaOverlayActions.spacer:
        return const Spacer();
      case MediaOverlayActions.download:
        return DownloadButton(
          tweet: tweet,
          media: media,
          sizeDelta: 2,
          foregroundColor: Colors.white,
          onDownload: delegates.onDownloadMedia,
        );
      case MediaOverlayActions.show:
        return ShowButton(
          tweet: tweet,
          sizeDelta: 2,
          foregroundColor: Colors.white,
          onShow: delegates.onShowTweet,
        );
      case MediaOverlayActions.actionsButton:
        return MoreActionsButton(
          tweet: tweet,
          sizeDelta: 2,
          foregroundColor: Colors.white,
          onViewMoreActions: (context, read) => showMediaActionsBottomSheet(
            context,
            read,
            media: media,
            delegates: delegates,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaQuery = MediaQuery.of(context);
    final display = ref.watch(displayPreferencesProvider);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black87,
          ],
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: display.smallPaddingValue)
          .copyWith(bottom: mediaQuery.padding.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _OverlayPreviewText(tweet: tweet, delegates: delegates),
          Row(
            children: [
              for (final action in actions)
                _mapAction(
                  context,
                  ref.read,
                  action: action,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OverlayPreviewText extends ConsumerWidget {
  const _OverlayPreviewText({
    required this.tweet,
    required this.delegates,
  });

  final TweetData tweet;
  final TweetDelegates delegates;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final display = ref.watch(displayPreferencesProvider);

    return Padding(
      padding: display.edgeInsetsSymmetric(horizontal: true) +
          EdgeInsets.symmetric(vertical: display.smallPaddingValue),
      child: AnimatedSize(
        duration: kShortAnimationDuration,
        alignment: Alignment.bottomCenter,
        curve: Curves.easeInOut,
        child: GestureDetector(
          onTap: () => delegates.onShowTweet?.call(context, ref.read),
          child: AnimatedSwitcher(
            duration: kShortAnimationDuration,
            switchInCurve: Curves.easeInCubic,
            switchOutCurve: Curves.easeOutCubic,
            layoutBuilder: (currentChild, previousChildren) => Stack(
              alignment: Alignment.bottomCenter,
              children: [
                ...previousChildren,
                if (currentChild != null) currentChild,
              ],
            ),
            child: Text(
              tweet.visibleText,
              key: ObjectKey(tweet),
              style: theme.textTheme.bodyText2!.copyWith(
                color: Colors.white,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
