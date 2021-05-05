import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

class RepliesScreen extends StatelessWidget {
  const RepliesScreen({
    required this.tweet,
  });

  final TweetData? tweet;

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
