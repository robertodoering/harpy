import 'package:dart_twitter_api/api/users/data/paginated_users.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

part 'following_event.dart';

class FollowingBloc extends FollowingFollowersBloc {
  FollowingBloc({
    @required String userId,
  }) : super(userId: userId) {
    add(const LoadFollowingUsers());
  }

  static FollowingBloc of(BuildContext context) =>
      context.watch<FollowingBloc>();
}
