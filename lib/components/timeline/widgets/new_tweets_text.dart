import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:rby/rby.dart';

class NewTweetsText extends StatelessWidget {
  const NewTweetsText(this.amount);

  final int amount;

  String get _text => amount > 0
      ? '$amount new tweet${amount > 1 ? 's' : ''} since last visit'
      : 'new tweets since last visit';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: theme.spacing.symmetric(horizontal: true),
      alignment: AlignmentDirectional.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(FeatherIcons.chevronsUp),
          HorizontalSpacer.normal,
          Text(_text, style: theme.textTheme.titleSmall),
        ],
      ),
    );
  }
}
