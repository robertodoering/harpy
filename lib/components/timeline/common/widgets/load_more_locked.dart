import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/timeline/common/bloc/timeline_bloc.dart';
import 'package:harpy/components/tweet/widgets/tweet_list.dart';

/// Builds a widget for the end of the [TweetList] when
/// [TimelineBloc.lockRequestMore] is `true`.
class LoadingMoreLocked extends StatelessWidget {
  const LoadingMoreLocked();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        height: 200,
        padding: const EdgeInsets.all(16),
        alignment: Alignment.center,
        child: const Text(
          'Please wait a moment until more Tweets can be requested',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
