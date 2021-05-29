import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:provider/provider.dart';

class TweetActionsButton extends StatelessWidget {
  const TweetActionsButton(
    this.tweet, {
    this.padding = const EdgeInsets.all(8),
    this.sizeDelta = 0,
  });

  final TweetData tweet;
  final EdgeInsets padding;
  final double sizeDelta;

  @override
  Widget build(BuildContext context) {
    return ViewMoreActionButton(
      padding: padding,
      sizeDelta: sizeDelta,
      onTap: () => context.read<TweetBloc>().onViewMoreActions(context, tweet),
    );
  }
}
