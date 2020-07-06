import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:harpy/components/application/bloc/application_bloc.dart';
import 'package:harpy/core/theme/harpy_theme.dart';

/// Builds a widget similar to a [SnackBar] that is intended to be shown at the
/// bottom of the screen with the [HarpyMessageHandler].
class HarpyMessage extends StatefulWidget {
  const HarpyMessage.info(this.text)
      : color = Colors.blue,
        icon = Icons.info_outline;

  const HarpyMessage.warning(this.text)
      : color = Colors.orange,
        icon = Icons.error_outline;

  const HarpyMessage.error(this.text)
      : color = Colors.red,
        icon = Icons.error_outline;

  /// The text for this message.
  final String text;

  /// The color for the icon and left bar.
  final Color color;

  /// The icon built to the left of the text.
  final IconData icon;

  @override
  _HarpyMessageState createState() => _HarpyMessageState();
}

class _HarpyMessageState extends State<HarpyMessage>
    with SingleTickerProviderStateMixin {
  final GlobalKey _boxKey = GlobalKey();

  /// Completes with the height of the background box for this message.
  ///
  /// Used to build the left bar in the message box.
  final Completer<double> _heightCompleter = Completer<double>();

  /// Fades the icon in and out repeatedly.
  AnimationController _fadeController;
  Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // setup icon fade animation
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _fadeAnimation = Tween<double>(begin: 1, end: 1 / 3).animate(
      _fadeController,
    );

    _fadeController.repeat(reverse: true);

    // setup message box height completer
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final RenderBox renderBox = _boxKey?.currentContext?.findRenderObject();

      _heightCompleter.complete(renderBox?.size?.height);
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();

    super.dispose();
  }

  Widget _buildLeftBar() {
    return FutureBuilder<double>(
      future: _heightCompleter.future,
      builder: (BuildContext context, AsyncSnapshot<double> height) {
        return Container(
          color: widget.color,
          width: 4,
          height: height.data,
        );
      },
    );
  }

  Widget _buildIcon() {
    return AnimatedBuilder(
      animation: _fadeController,
      builder: (BuildContext context, Widget child) => Opacity(
        opacity: _fadeAnimation.value,
        child: child,
      ),
      child: Icon(
        widget.icon,
        color: widget.color,
        size: 32,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final HarpyTheme theme = ApplicationBloc.of(context).harpyTheme;

    return SafeArea(
      left: false,
      right: false,
      top: false,
      bottom: true,
      child: Row(
        children: <Widget>[
          _buildLeftBar(),
          Expanded(
            child: Material(
              color: theme.backgroundColors.first,
              key: _boxKey,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    _buildIcon(),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(widget.text),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
