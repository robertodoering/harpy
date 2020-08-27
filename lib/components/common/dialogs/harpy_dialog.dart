import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:harpy/components/common/animations/explicit/bounce_in_animation.dart';
import 'package:harpy/components/common/animations/explicit/slide_in_animation.dart';
import 'package:harpy/components/common/buttons/harpy_button.dart';
import 'package:harpy/components/common/misc/harpy_background.dart';

/// Determines the animation that is used when building a [HarpyDialog].
enum DialogAnimationType {
  // the default material animation
  material,

  // a playful bounce in animation
  bounce,

  // a subtle slide animation
  slide,
}

/// A styled dialog used with [showDialog].
///
/// If the [actions] contain discard and confirm actions, the discard action
/// should always be on the left while the confirm action should be on the
/// right.
///
/// todo: refactor
class HarpyDialog extends StatefulWidget {
  const HarpyDialog({
    this.title,
    this.actions,
    this.text,
    this.body,
    this.padding = const EdgeInsets.all(16),
    this.actionsPadding = EdgeInsets.zero,
    this.backgroundColors,
    this.scrollPhysics = const BouncingScrollPhysics(),
    this.animationType = DialogAnimationType.bounce,
  });

  final String title;

  /// The actions that appear at the bottom of the dialog.
  final List<DialogAction<dynamic>> actions;

  /// The text is build below the [title] if not `null`.
  final String text;

  /// The body is build below the [text] if not `null`.
  final Widget body;

  /// The padding of the dialog content.
  final EdgeInsets padding;

  /// The padding for the actions.
  final EdgeInsets actionsPadding;

  /// The colors used by the [HarpyBackground].
  ///
  /// Uses the theme colors when `null`.
  final List<Color> backgroundColors;

  /// The scroll physics of the dialog (title, text + body).
  final ScrollPhysics scrollPhysics;

  /// Determines the animation used for building the harpy dialog.
  final DialogAnimationType animationType;

  @override
  _HarpyDialogState createState() => _HarpyDialogState();
}

class _HarpyDialogState extends State<HarpyDialog> {
  final GlobalKey _dialogKey = GlobalKey();

  final Completer<Size> _dialogSizeCompleter = Completer<Size>();

  bool get _hasActions => widget.actions?.isNotEmpty == true;

  @override
  void initState() {
    super.initState();

    _configureDialogSize();
  }

  Future<void> _configureDialogSize() async {
    SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
      final RenderBox box = _dialogKey?.currentContext?.findRenderObject();
      _dialogSizeCompleter.complete(box?.size);
    });
  }

  Widget _buildActions() {
    if (widget.actions.length > 1) {
      return FutureBuilder<Size>(
        future: _dialogSizeCompleter.future,
        builder: (BuildContext context, AsyncSnapshot<Size> snapshot) {
          return Container(
            width: snapshot?.data?.width,
            // padding: widget.actionsPadding,
            child: Wrap(
              alignment: WrapAlignment.spaceAround,
              children: widget.actions,
            ),
          );
        },
      );
    } else {
      return widget.actions.first;
    }
  }

  Widget _buildAnimation({@required Widget child}) {
    switch (widget.animationType) {
      case DialogAnimationType.slide:
        return SlideInAnimation(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutQuad,
          offset: const Offset(0, 40),
          child: child,
        );
      case DialogAnimationType.bounce:
        return BounceInAnimation(child: child);
        break;
      case DialogAnimationType.material:
      default:
        return child;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return _buildAnimation(
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: SizedBox(
          key: _dialogKey,
          child: HarpyBackground(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: widget.padding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (widget.title != null) ...<Widget>[
                    Text(
                      widget.title,
                      style: textTheme.headline6.copyWith(height: 1.2),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                  ],
                  Flexible(
                    child: SingleChildScrollView(
                      physics: widget.scrollPhysics,
                      child: Column(children: <Widget>[
                        if (widget.text != null) ...<Widget>[
                          Text(
                            widget.text,
                            style: textTheme.subtitle2,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                        ],
                        if (widget.body != null) widget.body,
                      ]),
                    ),
                  ),
                  if (_hasActions)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: _buildActions(),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// An action for a [HarpyDialog].
///
/// If [result] is not `null` the action will pop the dialog with the [result].
/// If [onTap] is not `null` the action will execute the callback.
///
/// The action will build a text button with [text] or an icon button with
/// [icon].
///
/// Either [text] or [icon] must not be `null`.
///
/// todo: refactor
class DialogAction<T> extends StatelessWidget {
  const DialogAction({
    this.result,
    this.onTap,
    this.text,
    this.icon,
    this.iconBuilder,
  })  : assert(result != null || onTap != null),
        assert(text != null || icon != null || iconBuilder != null);

  final T result;
  final VoidCallback onTap;
  final String text;
  final WidgetBuilder iconBuilder;
  final IconData icon;

  static DialogAction<bool> discard = const DialogAction<bool>(
    result: false,
    icon: Icons.close,
  );

  static DialogAction<bool> confirm = const DialogAction<bool>(
    result: true,
    icon: Icons.check,
  );

  @override
  Widget build(BuildContext context) {
    final Function callback = onTap ?? () => Navigator.of(context).pop(result);

    return HarpyButton.flat(
      text: text,
      icon: icon,
      iconBuilder: iconBuilder,
      onTap: callback,
      dense: true,
    );
  }
}
