import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/following_followers/common/bloc/following_followers_bloc.dart';
import 'package:harpy/components/following_followers/followers/bloc/followers_event.dart';

class FollowersBloc extends FollowingFollowersBloc {
  FollowersBloc({
    @required String userId,
  }) : super(userId: userId) {
    add(const LoadFollowers());
  }

  static FollowersBloc of(BuildContext context) =>
      context.watch<FollowersBloc>();
}
