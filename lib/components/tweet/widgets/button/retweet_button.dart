import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';

class RetweetButton extends ConsumerStatefulWidget {
  const RetweetButton({
    required this.tweet,
    required this.onRetweet,
    required this.onUnretweet,
    required this.onShowRetweeters,
    required this.onComposeQuote,
    this.sizeDelta = 0,
    this.foregroundColor,
  });

  final LegacyTweetData tweet;
  final TweetActionCallback? onRetweet;
  final TweetActionCallback? onUnretweet;
  final TweetActionCallback? onShowRetweeters;
  final TweetActionCallback? onComposeQuote;
  final double sizeDelta;
  final Color? foregroundColor;

  @override
  ConsumerState<RetweetButton> createState() => _RetweetButtonState();
}

class _RetweetButtonState extends ConsumerState<RetweetButton> {
  Future<void> _showMenu() async {
    final renderBox = context.findRenderObject()! as RenderBox;
    final overlay =
        Overlay.of(context).context.findRenderObject()! as RenderBox;

    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        renderBox.localToGlobal(
          renderBox.size.bottomLeft(Offset.zero),
          ancestor: overlay,
        ),
        renderBox.localToGlobal(
          renderBox.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    final result = await showRbyMenu(
      context: context,
      position: position,
      items: [
        RbyPopupMenuListTile(
          value: 0,
          leading: const Icon(FeatherIcons.repeat),
          title: Text(widget.tweet.retweeted ? 'unretweet' : 'retweet'),
        ),
        if (widget.onComposeQuote != null)
          const RbyPopupMenuListTile(
            value: 1,
            leading: Icon(FeatherIcons.feather),
            title: Text('quote tweet'),
          ),
        if (widget.onShowRetweeters != null)
          const RbyPopupMenuListTile(
            value: 2,
            leading: Icon(FeatherIcons.users),
            title: Text('view retweeters'),
          ),
      ],
    );

    if (mounted) {
      if (result == 0) {
        widget.tweet.retweeted
            ? widget.onUnretweet?.call(ref)
            : widget.onRetweet?.call(ref);
      } else if (result == 1) {
        widget.onComposeQuote?.call(ref);
      } else if (result == 2) {
        widget.onShowRetweeters?.call(ref);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final iconTheme = IconTheme.of(context);
    final harpyTheme = ref.watch(harpyThemeProvider);

    final iconSize = iconTheme.size! + widget.sizeDelta;

    return TweetActionButton(
      active: widget.tweet.retweeted,
      value: widget.tweet.retweetCount,
      iconBuilder: (_) => Icon(FeatherIcons.repeat, size: iconSize - 1),
      iconAnimationBuilder: (animation, child) => RotationTransition(
        turns: CurvedAnimation(curve: Curves.easeOutBack, parent: animation),
        child: child,
      ),
      bubblesColor: BubblesColor(
        primary: Colors.lime,
        secondary: Colors.limeAccent,
        tertiary: Colors.green,
        quaternary: Colors.green[900],
      ),
      circleColor: const CircleColor(start: Colors.green, end: Colors.lime),
      foregroundColor: widget.foregroundColor,
      iconSize: iconSize,
      sizeDelta: widget.sizeDelta,
      activeColor: harpyTheme.colors.retweet,
      activate: _showMenu,
      deactivate: _showMenu,
    );
  }
}
