import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/following_followers/common/bloc/following_followers_bloc.dart';
import 'package:harpy/components/following_followers/following/bloc/following_event.dart';

class FollowingBloc extends FollowingFollowersBloc {
  FollowingBloc({
    @required String userId,
  }) : super(userId: userId) {
    add(const LoadFollowingUsers());
  }

  static FollowingBloc of(BuildContext context) =>
      context.watch<FollowingBloc>();
}
