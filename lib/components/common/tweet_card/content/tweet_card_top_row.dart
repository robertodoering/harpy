import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:provider/provider.dart';

/// Builds the top row for the [TweetCardContent].
///
/// The top row consist of the following tweet card elements:
/// - [TweetCardElement.retweeter]
/// - [TweetCardElement.avatar]
/// - [TweetCardElement.name]
/// - [TweetCardElement.handle]
/// - [TweetCardElement.actionsButton]
class TweetCardTopRow extends StatelessWidget {
  const TweetCardTopRow({
    required this.outerPadding,
    required this.innerPadding,
    required this.config,
  });

  final double outerPadding;
  final double innerPadding;

  final TweetCardConfig config;

  @override
  Widget build(BuildContext context) {
    final tweet = context.select<TweetBloc, TweetData>((bloc) => bloc.tweet);

    final retweeter = TweetCardElement.retweeter.shouldBuild(tweet, config);
    final avatar = TweetCardElement.avatar.shouldBuild(tweet, config);
    final name = TweetCardElement.name.shouldBuild(tweet, config);
    final handle = TweetCardElement.handle.shouldBuild(tweet, config);
    final actionsButton = TweetCardElement.actionsButton.shouldBuild(
      tweet,
      config,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: outerPadding),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: outerPadding),
              if (retweeter) ...[
                TweetCardRetweeter(
                  style: TweetCardElement.retweeter.style(config),
                ),
                if (avatar && name && handle) SizedBox(height: innerPadding),
              ],
              GestureDetector(
                // treat the whitespace between the avatar and name as a on user
                //  tap gesture
                behavior: HitTestBehavior.translucent,
                onTap: () => context.read<TweetBloc>().onUserTap(context),
                child: Row(
                  children: [
                    if (avatar) ...[
                      TweetCardAvatar(
                        style: TweetCardElement.avatar.style(config),
                      ),
                      SizedBox(width: outerPadding),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (name)
                            TweetCardName(
                              style: TweetCardElement.name.style(config),
                            ),
                          if (name && handle)
                            SizedBox(height: innerPadding / 2),
                          if (handle)
                            TweetCardHandle(
                              style: TweetCardElement.handle.style(config),
                            ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: innerPadding),
            ],
          ),
        ),
        if (actionsButton)
          TweetCardActionsButton(
            padding: EdgeInsets.all(outerPadding).copyWith(
              left: innerPadding,
              bottom: innerPadding,
            ),
            style: TweetCardElement.actionsButton.style(config),
          ),
      ],
    );
  }
}
