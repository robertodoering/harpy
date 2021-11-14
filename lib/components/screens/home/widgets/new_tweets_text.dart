import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:harpy/components/components.dart';
import 'package:provider/provider.dart';

class NewTweetsText extends StatelessWidget {
  const NewTweetsText(this.amount);

  final int amount;

  String get _text => amount > 0
      ? '$amount new tweet${amount > 1 ? 's' : ''} since last visit'
      : 'new tweets since last visit';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = context.watch<ConfigCubit>().state;

    return Container(
      padding: config.edgeInsetsSymmetric(horizontal: true),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(FeatherIcons.chevronsUp),
          horizontalSpacer,
          Text(_text, style: theme.textTheme.subtitle2),
        ],
      ),
    );
  }
}
