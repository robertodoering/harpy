import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';

class ComposeTextField extends StatelessWidget {
  const ComposeTextField({
    required ComposeTextController controller,
    required FocusNode focusNode,
  })  : _controller = controller,
        _focusNode = focusNode;

  final ComposeTextController _controller;
  final FocusNode _focusNode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = context.watch<ConfigCubit>().state;

    final bloc = context.watch<ComposeBloc>();

    return Padding(
      padding: config.edgeInsetsSymmetric(horizontal: true),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        style: theme.textTheme.bodyText1,
        maxLines: null,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          hintText: bloc.inReplyToStatus != null
              ? 'tweet your reply'
              : "what's happening?",
          isDense: true,
          contentPadding: EdgeInsets.zero,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
      ),
    );
  }
}
