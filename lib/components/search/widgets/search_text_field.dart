import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/common/animations/animation_constants.dart';
import 'package:harpy/core/theme/harpy_theme.dart';

class SearchTextField extends StatefulWidget {
  const SearchTextField({
    this.onSubmitted,
    this.onClear,
    this.requestFocus = false,
  });

  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;
  final bool requestFocus;

  @override
  _SearchTextFieldState createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  TextEditingController _controller;
  FocusNode _focusNode;

  bool _showClear = false;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController()
      ..addListener(() {
        if (_showClear != _controller.value.text.isNotEmpty) {
          setState(() => _showClear = !_showClear);
        }
      });

    _focusNode = FocusNode();

    if (widget.requestFocus) {
      _focusNode.requestFocus();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _focusNode.dispose();
  }

  Widget _buildClearIcon(ThemeData theme) {
    Widget child;

    if (_showClear) {
      child = GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          _controller.clear();
          widget.onClear();
        },
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(
            Icons.close,
            color: theme.iconTheme.color.withOpacity(.7),
          ),
        ),
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

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final HarpyTheme harpyTheme = HarpyTheme.of(context);

    final Color fillColor = theme.brightness == Brightness.light
        ? Colors.black.withOpacity(.05)
        : Colors.white.withOpacity(.05);

    return Container(
      decoration: BoxDecoration(
        color: harpyTheme.backgroundColors.first,
        borderRadius: BorderRadius.circular(128),
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        onSubmitted: widget.onSubmitted,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          suffixIcon: widget.onClear != null ? _buildClearIcon(theme) : null,
          hintText: 'Search users',
          filled: true,
          fillColor: fillColor,
          isDense: true,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(128),
          ),
        ),
      ),
    );
  }
}
