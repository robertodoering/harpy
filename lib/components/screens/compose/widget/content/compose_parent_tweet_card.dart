import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:provider/provider.dart';

class ComposeParentTweetCard extends StatelessWidget {
  const ComposeParentTweetCard({
    required this.parentTweet,
    required this.text,
  });

  final TweetData parentTweet;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = context.watch<ConfigCubit>().state;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: config.paddingValue,
            vertical: config.smallPaddingValue,
          ),
          child: Row(
            children: [
              SizedBox(
                width: TweetCardAvatar.defaultRadius(config.fontSizeDelta) * 2,
                child: const Icon(CupertinoIcons.reply, size: 18),
              ),
              horizontalSpacer,
              Expanded(
                child: Text(
                  text,
                  style: theme.textTheme.subtitle1,
                ),
              ),
            ],
          ),
        ),
        verticalSpacer,
        TweetCard(parentTweet),
      ],
    );
  }
}
