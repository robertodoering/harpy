abstract class AuthenticationState {
  const AuthenticationState();
}

/// The state when the user has been authenticated.
///
/// [AuthenticationBloc.twitterSession] must not be `null` when the user is
/// authenticated.
class AuthenticatedState extends AuthenticationState {
  const AuthenticatedState();
}

/// The state when the user is currently attempting to authenticate.
class AwaitingAuthenticationState extends AuthenticationState {
  const AwaitingAuthenticationState();
}

/// The state when the user has not yet been authenticated.
class UnauthenticatedState extends AuthenticatedState {
  const UnauthenticatedState();
}
