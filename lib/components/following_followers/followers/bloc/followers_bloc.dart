import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/following_followers/common/bloc/following_followers_bloc.dart';

class FollowersBloc extends FollowingFollowersBloc {
  FollowersBloc({
    @required String userId,
  }) : super(userId: userId);

  static FollowersBloc of(BuildContext context) =>
      BlocProvider.of<FollowersBloc>(context);
}
