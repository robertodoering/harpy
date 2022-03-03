import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';

class SearchAppBar extends ConsumerWidget {
  const SearchAppBar({
    required this.onSubmitted,
    required this.onClear,
    this.text,
    this.actions,
    this.autofocus = false,
  });

  final String? text;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;
  final List<Widget>? actions;
  final bool autofocus;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return HarpySliverAppBar(
      key: ValueKey(text),
      fittedTitle: false,
      title: ClearableTextField(
        text: text,
        onSubmitted: onSubmitted,
        onClear: onClear,
        autofocus: autofocus,
      ),
      actions: actions,
    );
  }
}
