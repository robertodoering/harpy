import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/buttons/favorite_button.dart';
import 'package:harpy/components/common/buttons/harpy_button.dart';
import 'package:harpy/components/common/buttons/retweet_button.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';
import 'package:harpy/components/tweet/bloc/tweet_bloc.dart';
import 'package:harpy/components/tweet/bloc/tweet_state.dart';

class MediaOverlayActionRow extends StatelessWidget {
  const MediaOverlayActionRow(
    this.tweetBloc, {
    this.onDownload,
  });

  final TweetBloc tweetBloc;
  final VoidCallback onDownload;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Theme(
      data: theme.copyWith(
        iconTheme: theme.iconTheme.copyWith(size: 24),
        textTheme: theme.textTheme.copyWith(
          button: theme.textTheme.button.copyWith(fontSize: 18),
        ),
      ),
      child: BlocProvider<TweetBloc>.value(
        value: tweetBloc,
        child: BlocBuilder<TweetBloc, TweetState>(
          builder: (BuildContext context, TweetState state) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: <Widget>[
                  RetweetButton(tweetBloc),
                  defaultSmallHorizontalSpacer,
                  FavoriteButton(tweetBloc),
                  const Spacer(),
                  HarpyButton.flat(
                    icon: const Icon(Icons.download_rounded),
                    iconSize: 24,
                    padding: const EdgeInsets.all(8),
                    onTap: onDownload,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
