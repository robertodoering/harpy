import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';

class ComposeTextField extends ConsumerWidget {
  const ComposeTextField({
    required ComposeTextController controller,
    required FocusNode focusNode,
  })  : _controller = controller,
        _focusNode = focusNode;

  final ComposeTextController _controller;
  final FocusNode _focusNode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(composeProvider);

    return Padding(
      padding: theme.spacing.symmetric(horizontal: true),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 70),
        child: TextField(
          controller: _controller,
          focusNode: _focusNode,
          style: theme.textTheme.bodyLarge,
          maxLines: null,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            hintText: state.parentTweet != null
                ? 'tweet your reply'
                : "what's happening?",
            isDense: true,
            contentPadding: EdgeInsets.zero,
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
