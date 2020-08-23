import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:harpy/components/application/bloc/application_bloc.dart';
import 'package:harpy/components/authentication/bloc/authentication_event.dart';
import 'package:harpy/components/authentication/bloc/authentication_state.dart';
import 'package:harpy/components/settings/bloc/custom_theme/custom_theme_bloc.dart';
import 'package:harpy/core/api/twitter/user_data.dart';
import 'package:harpy/core/service_locator.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    @required this.customThemeBloc,
  }) : super(UnauthenticatedState());

  final TwitterApi twitterApi = app<TwitterApi>();

  /// A reference to the [CustomThemeBloc] to load the custom themes for the
  /// user after am authentication.
  final CustomThemeBloc customThemeBloc;

  /// A reference to the [ApplicationBloc].
  ApplicationBloc applicationBloc;

  /// The [twitterLogin] is used to log in and out with the native twitter sdk.
  TwitterLogin twitterLogin;

  /// The [twitterSession] contains information about the authenticated user.
  ///
  /// If the user is not authenticated, [twitterSession] will be `null`.
  TwitterSession twitterSession;

  /// Completes with either `true` or `false` whether the user has an active
  /// twitter session after initialization.
  Completer<bool> sessionInitialization = Completer<bool>();

  /// The [UserData] of the authenticated user.
  ///
  /// `null` if the user is not authenticated.
  UserData authenticatedUser;

  static AuthenticationBloc of(BuildContext context) =>
      BlocProvider.of<AuthenticationBloc>(context);

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    yield* event.applyAsync(currentState: state, bloc: this);
  }
}
