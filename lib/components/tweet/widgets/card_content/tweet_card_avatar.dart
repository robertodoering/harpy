import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

class TweetCardAvatar extends ConsumerWidget {
  const TweetCardAvatar({
    required this.tweet,
    required this.onUserTap,
    required this.style,
  });

  final TweetData tweet;
  final TweetActionCallback? onUserTap;
  final TweetCardElementStyle style;

  static const double _defaultRadius = 20;

  static double defaultRadius(double fontSizeDelta) {
    return _defaultRadius + fontSizeDelta;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(displayPreferencesProvider);

    return GestureDetector(
      onTap: () => onUserTap?.call(context, ref.read),
      child: HarpyCircleAvatar(
        imageUrl: tweet.user.appropriateUserImageUrl,
        radius: defaultRadius(display.fontSizeDelta) + style.sizeDelta,
      ),
    );
  }
}
