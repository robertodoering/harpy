import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

class MediaOverlayActionRow extends StatelessWidget {
  const MediaOverlayActionRow(
    this.tweetBloc, {
    @required this.onDownload,
    @required this.onOpenExternally,
    @required this.onShare,
    this.onShowTweet,
  });

  final TweetBloc tweetBloc;
  final VoidCallback onDownload;
  final VoidCallback onOpenExternally;
  final VoidCallback onShare;
  final VoidCallback onShowTweet;

  Widget _buildMoreActionsButton(HarpyTheme harpyTheme, BuildContext context) {
    return ViewMoreActionButton(
      onTap: () => showTweetMediaBottomSheet(
        context,
        onOpenExternally: onOpenExternally,
        onDownload: onDownload,
        onShare: onShare,
      ),
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
              CustomAnimatedSize(
                alignment: Alignment.centerLeft,
                child: RetweetButton(
                  tweetBloc,
                  padding: const EdgeInsets.all(16),
                ),
              ),
              defaultSmallHorizontalSpacer,
              CustomAnimatedSize(
                alignment: Alignment.centerLeft,
                child: FavoriteButton(
                  tweetBloc,
                  padding: const EdgeInsets.all(16),
                ),
              ),
              const Spacer(),
              if (onShowTweet != null)
                HarpyButton.flat(
                  padding: const EdgeInsets.all(16),
                  text: const Text('show'),
                  onTap: onShowTweet,
                )
              else
                HarpyButton.flat(
                  padding: const EdgeInsets.all(16),
                  icon: const Icon(CupertinoIcons.arrow_down_to_line),
                  onTap: onDownload,
                ),
              _buildMoreActionsButton(harpyTheme, context),
            ],
          ),
        ),
      ),
    );
  }
}
