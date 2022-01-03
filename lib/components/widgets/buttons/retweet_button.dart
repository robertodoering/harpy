import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';

/// The retweet button for a [TweetCardActionsRow].
class RetweetButton extends StatefulWidget {
  const RetweetButton({
    this.padding = const EdgeInsets.all(8),
    this.iconSize = 21,
    this.sizeDelta = 0,
    this.overlayForegroundColor,
  });

  final EdgeInsets padding;
  final double iconSize;
  final double sizeDelta;

  /// The foreground color for the icon an text in the retweet menu.
  ///
  /// Used in the [MediaOverlayActionRow] to override the color for light
  /// themes.
  final Color? overlayForegroundColor;

  @override
  _RetweetButtonState createState() => _RetweetButtonState();
}

class _RetweetButtonState extends State<RetweetButton> {
  Future<void> _showRetweetButtonMenu(TweetBloc bloc) async {
    final popupMenuTheme = PopupMenuTheme.of(context);

    final button = context.findRenderObject() as RenderBox;

    final overlay =
        Overlay.of(context)!.context.findRenderObject() as RenderBox;

    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(
          button.size.bottomLeft(Offset.zero),
          ancestor: overlay,
        ),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    final result = await showMenu<int>(
      context: context,
      elevation: popupMenuTheme.elevation,
      items: [
        HarpyPopupMenuItem(
          value: 0,
          icon: Icon(
            FeatherIcons.repeat,
            color: widget.overlayForegroundColor,
          ),
          text: Text(
            bloc.state.retweeted ? 'unretweet' : 'retweet',
            style: TextStyle(color: widget.overlayForegroundColor),
          ),
        ),
        HarpyPopupMenuItem(
          value: 1,
          icon: Icon(
            FeatherIcons.feather,
            color: widget.overlayForegroundColor,
          ),
          text: Text(
            'quote tweet',
            style: TextStyle(color: widget.overlayForegroundColor),
          ),
        ),
        const HarpyPopupMenuItem<int>(
          value: 2,
          icon: Icon(FeatherIcons.eye),
          text: Text('view retweeters'),
        ),
      ],
      position: position,
      shape: popupMenuTheme.shape,
      color: popupMenuTheme.color,
    );

    if (result == 0) {
      bloc.onToggleRetweet();
    } else if (result == 1) {
      bloc.onComposeQuote();
    } else if (result == 2) {
      bloc.onShowRetweeters();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final harpyTheme = context.watch<HarpyTheme>();

    final bloc = context.watch<TweetBloc>();

    return ActionButton(
      active: bloc.state.retweeted,
      padding: widget.padding,
      activeIconColor: harpyTheme.retweetColor,
      activeTextStyle: theme.textTheme.button!
          .copyWith(
            color: harpyTheme.retweetColor,
            fontWeight: FontWeight.bold,
          )
          .apply(fontSizeDelta: widget.sizeDelta),
      inactiveTextStyle: theme.textTheme.button!
          .copyWith(color: theme.textTheme.bodyText2!.color)
          .apply(fontSizeDelta: widget.sizeDelta),
      value: bloc.tweet.retweetCount,
      activate: () => _showRetweetButtonMenu(bloc),
      deactivate: () => _showRetweetButtonMenu(bloc),
      onLongPress: bloc.onShowRetweeters,
      bubblesColor: BubblesColor(
        dotPrimaryColor: Colors.lime,
        dotSecondaryColor: Colors.limeAccent,
        dotThirdColor: Colors.green,
        dotLastColor: Colors.green[900],
      ),
      circleColor: const CircleColor(
        start: Colors.green,
        end: Colors.lime,
      ),
      iconAnimationBuilder: (animation, child) => RotationTransition(
        turns: CurvedAnimation(
          curve: Curves.easeOutBack,
          parent: animation,
        ),
        child: child,
      ),
      iconSize: widget.iconSize,
      iconBuilder: (_, __, size) => Icon(FeatherIcons.repeat, size: size),
    );
  }
}
