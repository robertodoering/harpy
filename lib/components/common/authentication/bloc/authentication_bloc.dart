import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/misc/misc.dart';
import 'package:logging/logging.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    @required this.themeBloc,
  }) : super(UnauthenticatedState());

  final TwitterApi twitterApi = app<TwitterApi>();

  final AuthPreferences authPreferences = app<AuthPreferences>();

  /// A reference to the [ThemeBloc] to change the theme for the authenticated
  /// user and to load the custom themes of the user.
  final ThemeBloc themeBloc;

  /// Used to authenticate with Twitter through a web view.
  TwitterAuth twitterAuth;

  /// Contains the user id, token & secret for the current twitter session.
  ///
  /// If the user is not authenticated, [twitterAuthSession] will be `null`.
  TwitterAuthSession twitterAuthSession;

  /// Completes with either `true` or `false` whether the user has an active
  /// twitter session after initialization.
  Completer<bool> sessionInitialization = Completer<bool>();

  /// The [UserData] of the authenticated user.
  ///
  /// `null` if the user is not authenticated.
  UserData authenticatedUser;

  static AuthenticationBloc of(BuildContext context) =>
      context.watch<AuthenticationBloc>();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    yield* event.applyAsync(currentState: state, bloc: this);
  }
}
