import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/screens/likes_retweets/common/bloc/likes_retweets_bloc.dart';
import 'package:harpy/core/core.dart';

part 'retweets_event.dart';

class RetweetsBloc extends LikesRetweetsBloc {
  RetweetsBloc({
    required String? tweetId,
    String? sort,
  }) : super(tweetId: tweetId, sort: sort) {
    add(const LoadRetweets());
  }

  static RetweetsBloc of(BuildContext context) => context.watch<RetweetsBloc>();
}
