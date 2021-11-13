import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

class ComposeScreen extends StatelessWidget {
  const ComposeScreen({
    this.inReplyToStatus,
    this.quotedTweet,
  }) : assert(inReplyToStatus == null || quotedTweet == null);

  /// The tweet that the user is replying to.
  final TweetData? inReplyToStatus;

  /// The tweet that the user is quoting (aka retweeting with quote).
  final TweetData? quotedTweet;

  static const route = 'compose';

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigCubit>().state;

    return BlocProvider<ComposeBloc>(
      create: (context) => ComposeBloc(
        inReplyToStatus: inReplyToStatus,
        quotedTweet: quotedTweet,
      ),
      child: HarpyScaffold(
        title: 'compose tweet',
        buildSafeArea: true,
        body: Padding(
          padding: config.edgeInsets,
          child: inReplyToStatus != null || quotedTweet != null
              ? ComposeTweetCardWithParent(
                  inReplyToStatus: inReplyToStatus,
                  quotedTweet: quotedTweet,
                )
              : const ComposeTweetCard(),
        ),
      ),
    );
  }
}
