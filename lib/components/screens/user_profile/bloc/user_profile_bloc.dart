import 'dart:async';

import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/core/core.dart';
import 'package:pedantic/pedantic.dart';

part 'user_profile_event.dart';
part 'user_profile_state.dart';

// TODO: refactor
class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  UserProfileBloc({
    required String? screenName,
  }) : super(LoadingUserState()) {
    on<UserProfileEvent>((event, emit) => event.handle(this, emit));
    add(InitializeUserEvent(user: user, userHandle: screenName));
  }

  /// The [UserData] for the user to display.
  ///
  /// Set with an [InitializeUserEvent].
  UserData? user;

  static UserProfileBloc of(BuildContext context) =>
      context.watch<UserProfileBloc>();
}
