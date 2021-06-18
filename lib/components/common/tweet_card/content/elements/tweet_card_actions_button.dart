import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/core/services/service_locator.dart';
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
    final bloc = context.watch<TweetBloc>();

    final fontSizeDelta = app<LayoutPreferences>().fontSizeDelta;

    return ViewMoreActionButton(
      sizeDelta: fontSizeDelta + style.sizeDelta,
      padding: padding,
      onTap: () => bloc.onViewMoreActions(context),
    );
  }
}
