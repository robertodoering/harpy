import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';

class NewTweetsText extends ConsumerWidget {
  const NewTweetsText(this.amount);

  final int amount;

  String get _text => amount > 0
      ? '$amount new tweet${amount > 1 ? 's' : ''} since last visit'
      : 'new tweets since last visit';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final display = ref.watch(displayPreferencesProvider);

    return Container(
      padding: display.edgeInsetsSymmetric(horizontal: true),
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
