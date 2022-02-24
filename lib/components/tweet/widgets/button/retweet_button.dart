import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/rby/rby.dart';

class RetweetButton extends ConsumerStatefulWidget {
  const RetweetButton({
    required this.tweet,
    required this.onRetweet,
    required this.onUnretweet,
    required this.onShowRetweeters,
    required this.onComposeQuote,
    this.sizeDelta = 0,
    this.overlayForegroundColor,
  });

  final TweetData tweet;
  final TweetActionCallback? onRetweet;
  final TweetActionCallback? onUnretweet;
  final TweetActionCallback? onShowRetweeters;
  final TweetActionCallback? onComposeQuote;
  final double sizeDelta;

  /// The foreground color for the icon an text in the retweet menu.
  ///
  /// Used in the to override the color for light themes in the media overlay.
  final Color? overlayForegroundColor;

  @override
  _RetweetButtonState createState() => _RetweetButtonState();
}

class _RetweetButtonState extends ConsumerState<RetweetButton> {
  Future<void> _showMenu() async {
    final popupMenuTheme = PopupMenuTheme.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final overlay =
        Overlay.of(context)!.context.findRenderObject() as RenderBox;

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

    final result = await showHarpyMenu(
      context: context,
      position: position,
      elevation: popupMenuTheme.elevation,
      shape: popupMenuTheme.shape,
      color: popupMenuTheme.color,
      items: [
        HarpyPopupMenuItem(
          value: 0,
          leading: Icon(
            FeatherIcons.repeat,
            color: widget.overlayForegroundColor,
          ),
          title: Text(
            widget.tweet.retweeted ? 'unretweet' : 'retweet',
            style: TextStyle(color: widget.overlayForegroundColor),
          ),
        ),
        HarpyPopupMenuItem(
          value: 1,
          leading: Icon(
            FeatherIcons.feather,
            color: widget.overlayForegroundColor,
          ),
          title: Text(
            'quote tweet',
            style: TextStyle(color: widget.overlayForegroundColor),
          ),
        ),
        if (widget.onShowRetweeters != null)
          HarpyPopupMenuItem(
            value: 2,
            leading: Icon(
              FeatherIcons.eye,
              color: widget.overlayForegroundColor,
            ),
            title: Text(
              'view retweeters',
              style: TextStyle(color: widget.overlayForegroundColor),
            ),
          ),
      ],
    );

    if (mounted) {
      if (result == 0) {
        widget.tweet.retweeted
            ? widget.onUnretweet?.call(context, ref.read)
            : widget.onRetweet?.call(context, ref.read);
      } else if (result == 1) {
        widget.onComposeQuote?.call(context, ref.read);
      } else if (result == 2) {
        widget.onShowRetweeters?.call(context, ref.read);
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
      iconSize: iconSize,
      sizeDelta: widget.sizeDelta,
      activeColor: harpyTheme.colors.retweet,
      activate: _showMenu,
      deactivate: _showMenu,
    );
  }
}
