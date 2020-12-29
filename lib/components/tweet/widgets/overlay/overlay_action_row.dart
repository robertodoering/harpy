import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/buttons/favorite_button.dart';
import 'package:harpy/components/common/buttons/harpy_button.dart';
import 'package:harpy/components/common/buttons/retweet_button.dart';
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
  });

  final TweetBloc tweetBloc;
  final VoidCallback onDownload;
  final VoidCallback onOpenExternally;

  Widget _buildMoreActionsButton(HarpyTheme harpyTheme, BuildContext context) {
    return HarpyButton.flat(
      icon: const Icon(Icons.more_vert),
      padding: const EdgeInsets.all(16),
      onTap: () {
        showModalBottomSheet<void>(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: kDefaultRadius,
              topRight: kDefaultRadius,
            ),
          ),
          builder: (BuildContext context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // handle
              Container(
                width: 50,
                height: 2,
                margin: EdgeInsets.all(defaultPaddingValue / 4),
                decoration: BoxDecoration(
                  borderRadius: kDefaultBorderRadius,
                  color: harpyTheme.foregroundColor.withOpacity(.2),
                ),
              ),
              defaultSmallVerticalSpacer,
              ListTile(
                leading: const Icon(Icons.open_in_browser),
                title: const Text('Open externally'),
                onTap: () {
                  onOpenExternally?.call();
                  app<HarpyNavigator>().state.maybePop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.file_download),
                title: const Text('Download'),
                onTap: () {
                  onDownload?.call();
                  app<HarpyNavigator>().state.maybePop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Share'),
                onTap: () {
                  app<HarpyNavigator>().state.maybePop();
                },
                enabled: false, // todo: implement share media
              ),
            ],
          ),
        );
      },
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
