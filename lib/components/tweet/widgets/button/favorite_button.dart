import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

class FavoriteButton extends ConsumerWidget {
  const FavoriteButton({
    required this.tweet,
    required this.onFavorite,
    required this.onUnfavorite,
    this.sizeDelta = 0,
    this.foregroundColor,
  });

  final LegacyTweetData tweet;
  final TweetActionCallback? onFavorite;
  final TweetActionCallback? onUnfavorite;
  final double sizeDelta;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final iconTheme = IconTheme.of(context);
    final harpyTheme = ref.watch(harpyThemeProvider);

    final iconSize = iconTheme.size! + sizeDelta;

    return TweetActionButton(
      active: tweet.favorited,
      value: tweet.favoriteCount,
      iconBuilder: (_) => Icon(
        tweet.favorited ? CupertinoIcons.heart_solid : CupertinoIcons.heart,
        size: iconSize,
      ),
      foregroundColor: foregroundColor,
      iconSize: iconSize,
      sizeDelta: sizeDelta,
      activeColor: harpyTheme.colors.favorite,
      activate: () => onFavorite?.call(ref),
      deactivate: () => onUnfavorite?.call(ref),
    );
  }
}
