import 'package:flutter/material.dart';
import 'package:harpy/components/compose/widget/compose_text_controller.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';

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

    return Padding(
      padding: DefaultEdgeInsets.symmetric(horizontal: true),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        style: theme.textTheme.bodyText1,
        maxLines: null,
        decoration: const InputDecoration(
          hintText: "What's happening?",
          isDense: true,
          contentPadding: EdgeInsets.zero,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
