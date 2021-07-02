import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:provider/provider.dart';

class TweetCardActionsButton extends StatelessWidget {
  const TweetCardActionsButton({
    required this.padding,
    required this.style,
  });

  final EdgeInsets padding;
  final TweetCardElementStyle style;

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigBloc>().state;

    final bloc = context.watch<TweetBloc>();

    final fontSizeDelta = config.fontSizeDelta + style.sizeDelta;

    return ViewMoreActionButton(
      sizeDelta: fontSizeDelta,
      padding: padding,
      onTap: () => bloc.onViewMoreActions(context),
    );
  }
}
