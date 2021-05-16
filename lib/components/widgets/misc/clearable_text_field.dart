import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

/// Builds a [TextField] with a clear button when it's value is not empty.
class ClearableTextField extends StatefulWidget {
  const ClearableTextField({
    this.controller,
    this.text,
    this.decoration,
    this.autofocus = false,
    this.removeFocusOnClear = false,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
  });

  final TextEditingController? controller;
  final String? text;
  final InputDecoration? decoration;
  final bool autofocus;
  final bool removeFocusOnClear;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;

  @override
  _ClearableTextFieldState createState() => _ClearableTextFieldState();
}

class _ClearableTextFieldState extends State<ClearableTextField> {
  late TextEditingController _controller;
  FocusNode? _focusNode;

  bool _showClear = false;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller ?? TextEditingController();

    if (widget.text != null) {
      _controller.text = widget.text!;
    }

    _controller.addListener(() {
      if (mounted && _showClear != _controller.value.text.isNotEmpty) {
        setState(() => _showClear = !_showClear);
      }
    });

    _focusNode = FocusNode();
    if (widget.autofocus) {
      _focusNode!.requestFocus();
    }
  }

  @override
  void didUpdateWidget(covariant ClearableTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.text != null && _controller.text != widget.text) {
      _controller.value = TextEditingValue(text: widget.text!);
    }
  }

  @override
  void dispose() {
    super.dispose();

    if (widget.controller == null) {
      _controller.dispose();
    }
    _focusNode!.dispose();
  }

  Widget _buildClearIcon(ThemeData theme) {
    Widget child;

    if (_showClear) {
      child = HarpyButton.flat(
        dense: true,
        icon: Icon(
          CupertinoIcons.xmark,
          size: 18,
          color: theme.iconTheme.color,
        ),
        onTap: () {
          _controller.clear();
          widget.onClear?.call();
          widget.onChanged?.call('');

          if (widget.removeFocusOnClear) {
            // prevents the text field from gaining focus when previously
            // unfocused upon tapping the clear button
            _focusNode!.canRequestFocus = false;
          }
        },
      );
    } else {
      child = const SizedBox();
    }

    return AnimatedSwitcher(
      duration: kShortAnimationDuration,
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      child: child,
    );
  }

  InputDecoration _buildDecoration(ThemeData theme) {
    if (widget.decoration != null) {
      return widget.decoration!.copyWith(suffixIcon: _buildClearIcon(theme));
    } else {
      return InputDecoration(suffixIcon: _buildClearIcon(theme));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      decoration: _buildDecoration(theme),
    );
  }
}
