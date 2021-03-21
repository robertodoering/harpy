import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';

class ComposeTextField extends StatelessWidget {
  const ComposeTextField({
    Key key,
    @required ComposeTextController controller,
    @required FocusNode focusNode,
  })  : _controller = controller,
        _focusNode = focusNode,
        super(key: key);

  final ComposeTextController _controller;
  final FocusNode _focusNode;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ComposeBloc bloc = context.watch<ComposeBloc>();

    return Padding(
      padding: DefaultEdgeInsets.symmetric(horizontal: true),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        style: theme.textTheme.bodyText1,
        maxLines: null,
        decoration: InputDecoration(
          hintText: bloc.hintText,
          isDense: true,
          contentPadding: EdgeInsets.zero,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
