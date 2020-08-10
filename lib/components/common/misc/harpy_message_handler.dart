import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:harpy/components/common/animations/animation_constants.dart';
import 'package:harpy/components/common/misc/shifted_position.dart';

/// The default duration a message is shown on screen.
const Duration kMessageShowDuration = Duration(seconds: 3);

/// Used to show messages at the bottom of the screen above the [child].
///
/// Similar to using [Scaffold.of(context).showSnackBar] with a [SnackBar] but
/// can be used with a [GlobalKey] to show message globally without a
/// [BuildContext].
///
/// Messages are showing on screen for [kMessageShowDuration] and can be hidden
/// prematurely by tapping on it.
class HarpyMessageHandler extends StatefulWidget {
  const HarpyMessageHandler({
    @required this.child,
    Key key,
  }) : super(key: key);

  final Widget child;

  static final GlobalKey<HarpyMessageHandlerState> globalKey =
      GlobalKey<HarpyMessageHandlerState>();

  @override
  HarpyMessageHandlerState createState() => HarpyMessageHandlerState();
}

class HarpyMessageHandlerState extends State<HarpyMessageHandler>
    with SingleTickerProviderStateMixin {
  /// The queue of messages.
  final Queue<Widget> _messages = Queue<Widget>();

  /// Whether the queue of messages is not empty.
  bool get _hasMessage => _messages.isNotEmpty;

  /// Whether a message is currently showing
  bool _showing = false;

  AnimationController _controller;
  Animation<Offset> _offsetAnimation;

  Completer<void> _hideMessageCompleter;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: kShortAnimationDuration,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurveTween(curve: Curves.fastOutSlowIn).animate(_controller));

    super.initState();
  }

  /// Shows the [message] at the bottom of the screen or adds it to the
  /// [_messages] queue.
  void showMessage(Widget message) {
    _messages.addLast(message);

    if (!_showing) {
      _showNextMessages();
    }
  }

  /// Starts the animation to show the next message and then removes it from the
  /// [_messages] queue.
  ///
  /// The animation repeats for the next message until the queue is empty.
  Future<void> _showNextMessages() async {
    _hideMessageCompleter = Completer<void>();
    _showing = true;

    await _controller.forward();

    Future<void>.delayed(kMessageShowDuration).then((_) {
      if (!_hideMessageCompleter.isCompleted) {
        _hideMessageCompleter.complete();
      }
    });

    await _hideMessageCompleter.future;

    await _controller.reverse();
    _messages.removeFirst();

    if (_hasMessage) {
      _showNextMessages();
    } else {
      _showing = false;
    }
  }

  Widget _buildMessage() {
    return GestureDetector(
      onTapDown: (_) {
        if (_hideMessageCompleter?.isCompleted == false) {
          _hideMessageCompleter.complete();
        }
      },
      child: _messages.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        widget.child,
        Align(
          alignment: Alignment.bottomCenter,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, Widget child) => _hasMessage
                ? ShiftedPosition(
                    shift: _offsetAnimation.value,
                    child: _buildMessage(),
                  )
                : const SizedBox(),
          ),
        ),
      ],
    );
  }
}
