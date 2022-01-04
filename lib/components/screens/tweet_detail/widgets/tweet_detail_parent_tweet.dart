import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

/// Builds the parent tweet for the [TweetDetailScreen].
///
/// When the parent is loaded, the tweet card will animate into view.
/// If now parent tweet exist, only a [verticalSpacer] is built.
class TweetDetailParentTweet extends StatelessWidget {
  const TweetDetailParentTweet();

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigCubit>().state;
    final cubit = context.watch<RepliesCubit>();
    final state = cubit.state;

    return SliverToBoxAdapter(
      child: AnimatedSize(
        duration: kLongAnimationDuration,
        curve: Curves.easeOutCubic,
        alignment: Alignment.topCenter,
        child: state.hasParent
            ? Column(
                children: [
                  Padding(
                    padding: config.edgeInsets.copyWith(bottom: 0),
                    child: TweetCard(state.parent!),
                  ),
                  verticalSpacer,
                  TweetListInfoRow(
                    icon: const Icon(CupertinoIcons.reply),
                    text: Text('${cubit.tweet.user.name} replied'),
                  ),
                  verticalSpacer,
                ],
              )
            : verticalSpacer,
      ),
    );
  }
}
