import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:provider/provider.dart';

class TweetCardAvatar extends StatelessWidget {
  const TweetCardAvatar({
    required this.style,
  });

  final TweetCardElementStyle style;

  static const double _defaultRadius = 20;

  static double get defaultRadius {
    final fontSizeDelta = app<LayoutPreferences>().fontSizeDelta;

    return _defaultRadius + fontSizeDelta;
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<TweetBloc>();
    final tweet = bloc.state.tweet;

    return GestureDetector(
      onTap: () => bloc.onUserTap(context),
      child: HarpyCircleAvatar(
        imageUrl: tweet.user.appropriateUserImageUrl,
        radius: defaultRadius + style.sizeDelta,
      ),
    );
  }
}
