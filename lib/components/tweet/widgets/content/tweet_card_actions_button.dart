import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

class TweetCardActionsButton extends StatelessWidget {
  const TweetCardActionsButton({
    required this.tweet,
    required this.padding,
    required this.style,
  });

  final TweetData tweet;
  final EdgeInsets padding;
  final TweetCardElementStyle style;

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
    // TODO: actions button
    // return ViewMoreActionButton(
    //   sizeDelta: style.sizeDelta,
    //   padding: padding,
    //   onTap: () => bloc.onViewMoreActions(context),
    // );
  }
}
