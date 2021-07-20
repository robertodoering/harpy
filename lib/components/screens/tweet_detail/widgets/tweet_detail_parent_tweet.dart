import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

/// Builds the parent tweet for the [TweetDetailScreen].
///
/// When the parent is loaded, the tweet card will animate into view.
/// If now parent tweet exist, only a [defaultVerticalSpacer] is built.
class TweetDetailParentTweet extends StatelessWidget {
  const TweetDetailParentTweet();

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigCubit>().state;
    final bloc = context.watch<RepliesBloc>();
    final state = bloc.state;

    return SliverToBoxAdapter(
      child: CustomAnimatedSize(
        duration: kLongAnimationDuration,
        alignment: Alignment.topCenter,
        child: state.hasParent
            ? Column(
                children: [
                  Padding(
                    padding: config.edgeInsets.copyWith(bottom: 0),
                    // todo: tweet card should not have an animation
                    child: TweetCard(state.parent!),
                  ),
                  defaultVerticalSpacer,
                  TweetListInfoRow(
                    icon: const Icon(CupertinoIcons.reply),
                    text: Text('${bloc.tweet.user.name} replied'),
                  ),
                  defaultVerticalSpacer,
                ],
              )
            : defaultVerticalSpacer,
      ),
    );
  }
}
