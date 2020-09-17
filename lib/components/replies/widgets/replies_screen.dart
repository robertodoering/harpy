import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/animations/animation_constants.dart';
import 'package:harpy/components/common/misc/harpy_background.dart';
import 'package:harpy/components/replies/bloc/replies_bloc.dart';
import 'package:harpy/components/replies/bloc/replies_state.dart';
import 'package:harpy/components/replies/widgets/content/replies_content.dart';
import 'package:harpy/components/replies/widgets/content/replies_parent_loading.dart';
import 'package:harpy/core/api/twitter/tweet_data.dart';

class RepliesScreen extends StatelessWidget {
  const RepliesScreen({
    @required this.tweet,
  });

  final TweetData tweet;

  static const String route = 'replies';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RepliesBloc>(
      create: (BuildContext context) => RepliesBloc(tweet),
      child: BlocBuilder<RepliesBloc, RepliesState>(
        builder: (BuildContext context, RepliesState state) {
          final RepliesBloc bloc = RepliesBloc.of(context);

          Widget child;

          if (state is LoadingParentsState) {
            child = const RepliesParentLoading();
          } else {
            child = RepliesContent(bloc: bloc);
          }

          return HarpyBackground(
            child: AnimatedSwitcher(
              duration: kShortAnimationDuration,
              switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
              child: child,
            ),
          );
        },
      ),
    );
  }
}
