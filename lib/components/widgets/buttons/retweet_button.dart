import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';

/// The retweet button for a [TweetActionRow].
class RetweetButton extends StatefulWidget {
  const RetweetButton(
    this.bloc, {
    this.padding = const EdgeInsets.all(8),
  });

  final TweetBloc bloc;
  final EdgeInsets padding;

  @override
  _RetweetButtonState createState() => _RetweetButtonState();
}

class _RetweetButtonState extends State<RetweetButton> {
  Future<void> _showRetweetButtonMenu() async {
    final popupMenuTheme = PopupMenuTheme.of(context);

    final button = context.findRenderObject() as RenderBox;

    final overlay =
        Overlay.of(context)!.context.findRenderObject() as RenderBox;

    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(
          button.size.bottomLeft(Offset.zero) - const Offset(0, 24),
          ancestor: overlay,
        ),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero) - const Offset(0, 24),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    final result = await showMenu<int>(
      context: context,
      elevation: popupMenuTheme.elevation,
      items: const <PopupMenuEntry<int>>[
        HarpyPopupMenuItem<int>(
          value: 0,
          icon: Icon(FeatherIcons.repeat),
          text: Text('retweet'),
        ),
        HarpyPopupMenuItem<int>(
          value: 1,
          icon: Icon(FeatherIcons.feather),
          text: Text('quote tweet'),
        ),
      ],
      position: position,
      shape: popupMenuTheme.shape,
      color: popupMenuTheme.color,
    );

    if (result == 0) {
      widget.bloc.onRetweet();
    } else if (result == 1) {
      widget.bloc.onComposeQuote();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<TweetBloc>();
    final harpyTheme = HarpyTheme.of(context);

    return ActionButton(
      active: widget.bloc.state.tweet.retweeted,
      padding: widget.padding,
      activeIconColor: harpyTheme.retweetColor,
      activeTextStyle: TextStyle(
        color: harpyTheme.retweetColor,
        fontWeight: FontWeight.bold,
      ),
      value: widget.bloc.state.tweet.retweetCount,
      activate: _showRetweetButtonMenu,
      deactivate: bloc.onUnretweet,
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
      iconSize: 20,
      iconBuilder: (_, __, size) => Icon(FeatherIcons.repeat, size: size),
    );
  }
}
