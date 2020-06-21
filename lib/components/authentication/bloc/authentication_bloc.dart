import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:harpy/components/authentication/bloc/authentication_event.dart';
import 'package:harpy/components/authentication/bloc/authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  /// The [twitterLogin] is used to log in and out with the native twitter sdk.
  TwitterLogin twitterLogin;

  /// The [twitterSession] contains information about the authenticated user.
  ///
  /// If the user is not authenticated, [twitterSession] will be `null`.
  TwitterSession twitterSession;

  /// The [TwitterApi] used to make authenticated requests to twitter.
  ///
  /// /// If the user is not authenticated, [twitterApi] will be `null`.
  TwitterApi twitterApi;

  /// Completes with either `true` or `false` whether the user has an active
  /// twitter session after initialization.
  Completer<bool> sessionInitialization = Completer<bool>();

  static AuthenticationBloc of(BuildContext context) =>
      BlocProvider.of<AuthenticationBloc>(context);

  @override
  AuthenticationState get initialState => const UnauthenticatedState();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    yield* event.applyAsync(currentState: state, bloc: this);
  }
}
