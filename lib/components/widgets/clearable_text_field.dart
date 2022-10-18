import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rby/rby.dart';

class ClearableTextField extends ConsumerStatefulWidget {
  const ClearableTextField({
    this.text,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.autofocus = false,
    this.decoration,
    this.inputFormatters,
  });

  final String? text;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final bool autofocus;
  final InputDecoration? decoration;
  final List<TextInputFormatter>? inputFormatters;

  @override
  ConsumerState<ClearableTextField> createState() => _ClearableTextFieldState();
}

class _ClearableTextFieldState extends ConsumerState<ClearableTextField> {
  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: widget.text)
      ..addListener(() => mounted ? setState(() {}) : null);
  }

  @override
  void didUpdateWidget(covariant ClearableTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.text != null &&
        widget.text != oldWidget.text &&
        widget.text != _controller.text) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.text = widget.text!;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final iconTheme = IconTheme.of(context);

    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      autofocus: widget.autofocus,
      inputFormatters: widget.inputFormatters,
      decoration: InputDecoration(
        label: widget.decoration?.label,
        labelText: widget.decoration?.labelText,
        isDense: widget.decoration?.isDense,
        suffixIcon: RbyButton.transparent(
          icon: Icon(CupertinoIcons.xmark, size: iconTheme.size),
          onTap: _controller.text.isNotEmpty
              ? () {
                  _controller.clear();
                  widget.onClear?.call();
                  _focusNode.unfocus();
                }
              : null,
        ),
      ),
    );
  }
}
