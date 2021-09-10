import 'package:flutter/material.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:intl/intl.dart';

/// Implicitly animations a change to [number].
///
/// The [number] is formatted using the [numberFormat]. An animation only
/// displays when the formatted number changes.
class AnimatedNumber extends StatefulWidget {
  AnimatedNumber({
    required this.number,
    NumberFormat? numberFormat,
  }) : numberFormat = numberFormat ?? NumberFormat.compact();

  final int? number;
  final NumberFormat numberFormat;

  @override
  _AnimatedNumberState createState() => _AnimatedNumberState();
}

class _AnimatedNumberState extends State<AnimatedNumber>
    with SingleTickerProviderStateMixin<AnimatedNumber> {
  late AnimationController _controller;
  late Animation<Offset> _oldSlideAnimation;
  late Animation<Offset> _newSlideAnimation;
  late Animation<double> _opacityAnimation;

  int? _oldNumber;
  String? _oldNumberStr;
  String? _newNumberStr;

  @override
  void initState() {
    super.initState();

    _newNumberStr = widget.numberFormat.format(widget.number);
    _oldNumberStr = _newNumberStr;
    _oldNumber = widget.number;

    _controller = AnimationController(
      duration: kShortAnimationDuration,
      vsync: this,
    );

    _oldSlideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 1),
    ).animate(CurvedAnimation(curve: Curves.easeInOut, parent: _controller));

    _newSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(curve: Curves.easeInOut, parent: _controller));

    _opacityAnimation = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(CurvedAnimation(curve: Curves.easeOut, parent: _controller));
  }

  @override
  void didUpdateWidget(AnimatedNumber oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.number != widget.number) {
      _newNumberStr = widget.numberFormat.format(widget.number);
      if (!_controller.isAnimating) {
        _controller.forward(from: 0).then((_) {
          _oldNumberStr = _newNumberStr;
          _oldNumber = widget.number;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_oldNumberStr != _newNumberStr) {
      var changedIndex = 0;

      if (_oldNumberStr!.length == _newNumberStr!.length) {
        for (var i = 0; i < _oldNumberStr!.length; i++) {
          if (_oldNumberStr![i] != _newNumberStr![i]) {
            changedIndex = i;
            break;
          }
        }
      }

      // the unchanged part of the text
      final unchanged = _newNumberStr!.substring(0, changedIndex);

      // the old text that should animate out
      final oldText = _oldNumberStr!.substring(
        changedIndex,
        _oldNumberStr!.length,
      );

      // the new text that should animate in
      final newText = _newNumberStr!.substring(
        changedIndex,
        _newNumberStr!.length,
      );

      return ClipRect(
        child: AnimatedSize(
          duration: kShortAnimationDuration,
          curve: Curves.easeOutCubic,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (_, __) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(unchanged),
                Stack(
                  fit: StackFit.passthrough,
                  children: [
                    FractionalTranslation(
                      translation: _oldNumber! > widget.number!
                          ? _newSlideAnimation.value
                          : -_newSlideAnimation.value,
                      child: Text(newText),
                    ),
                    Opacity(
                      opacity: _opacityAnimation.value,
                      child: FractionalTranslation(
                        translation: _oldNumber! > widget.number!
                            ? _oldSlideAnimation.value
                            : -_oldSlideAnimation.value,
                        child: Text(oldText),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    } else {
      return Text(_newNumberStr!);
    }
  }
}
