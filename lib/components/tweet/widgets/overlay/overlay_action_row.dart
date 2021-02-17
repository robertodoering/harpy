import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/buttons/favorite_button.dart';
import 'package:harpy/components/common/buttons/retweet_button.dart';
import 'package:harpy/components/common/buttons/view_more_action_button.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';
import 'package:harpy/components/tweet/bloc/tweet_bloc.dart';
import 'package:harpy/components/tweet/bloc/tweet_state.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/core/theme/harpy_theme.dart';
import 'package:harpy/misc/harpy_navigator.dart';

class MediaOverlayActionRow extends StatelessWidget {
  const MediaOverlayActionRow(
    this.tweetBloc, {
    this.onDownload,
    this.onOpenExternally,
    this.onShare,
  });

  final TweetBloc tweetBloc;
  final VoidCallback onDownload;
  final VoidCallback onOpenExternally;
  final VoidCallback onShare;

  Widget _buildMoreActionsButton(HarpyTheme harpyTheme, BuildContext context) {
    return ViewMoreActionButton(
      children: <Widget>[
        ListTile(
          leading: const Icon(CupertinoIcons.square_arrow_left),
          title: const Text('open externally'),
          onTap: () {
            onOpenExternally?.call();
            app<HarpyNavigator>().state.maybePop();
          },
        ),
        ListTile(
          leading: const Icon(CupertinoIcons.arrow_down_to_line),
          title: const Text('download'),
          onTap: () {
            onDownload?.call();
            app<HarpyNavigator>().state.maybePop();
          },
        ),
        ListTile(
          leading: const Icon(CupertinoIcons.share),
          title: const Text('share'),
          onTap: () {
            onShare?.call();
            app<HarpyNavigator>().state.maybePop();
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final HarpyTheme harpyTheme = HarpyTheme.of(context);

    return Theme(
      data: theme.copyWith(
        // force foreground colors to be white since they are always on a
        // dark background (independent of the theme)
        iconTheme: theme.iconTheme.copyWith(size: 24, color: Colors.white),
        textTheme: theme.textTheme.copyWith(
          button: theme.textTheme.button.copyWith(
            fontSize: 18,
            color: Colors.white,
          ),
          bodyText2: theme.textTheme.bodyText2.copyWith(
            color: Colors.white,
          ),
        ),
      ),
      child: BlocProvider<TweetBloc>.value(
        value: tweetBloc,
        child: BlocBuilder<TweetBloc, TweetState>(
          builder: (BuildContext context, TweetState state) => Row(
            children: <Widget>[
              RetweetButton(tweetBloc, padding: const EdgeInsets.all(16)),
              defaultSmallHorizontalSpacer,
              FavoriteButton(tweetBloc, padding: const EdgeInsets.all(16)),
              const Spacer(),
              _buildMoreActionsButton(harpyTheme, context),
            ],
          ),
        ),
      ),
    );
  }
}
