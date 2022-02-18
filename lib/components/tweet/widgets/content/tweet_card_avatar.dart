import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

class TweetCardAvatar extends ConsumerWidget {
  const TweetCardAvatar({
    required this.tweet,
    required this.style,
  });

  final TweetData tweet;
  final TweetCardElementStyle style;

  static const double _defaultRadius = 20;

  static double defaultRadius(double fontSizeDelta) {
    return _defaultRadius + fontSizeDelta;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(displayPreferencesProvider);

    return GestureDetector(
      // TODO: on user tap
      // onTap: () => bloc.onUserTap(context),
      child: HarpyCircleAvatar(
        imageUrl: tweet.user.appropriateUserImageUrl,
        radius: defaultRadius(display.fontSizeDelta) + style.sizeDelta,
      ),
    );
  }
}
