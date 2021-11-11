import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/screens/likes_retweets/common/bloc/likes_retweets_bloc.dart';
import 'package:harpy/core/core.dart';

part 'likes_event.dart';

class LikesBloc extends LikesRetweetsBloc {
  LikesBloc({
    required String? tweetId,
  }) : super(tweetId: tweetId) {
    add(const LoadLikes());
  }

  static LikesBloc of(BuildContext context) =>
      context.watch<LikesBloc>();
}
