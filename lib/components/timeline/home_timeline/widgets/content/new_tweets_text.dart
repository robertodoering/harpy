import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';

class NewTweetsText extends StatelessWidget {
  const NewTweetsText();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      padding: DefaultEdgeInsets.symmetric(horizontal: true),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(CupertinoIcons.chevron_up),
          defaultHorizontalSpacer,
          Text(
            'new tweets since last visit',
            style: theme.textTheme.subtitle2,
          ),
        ],
      ),
    );
  }
}
