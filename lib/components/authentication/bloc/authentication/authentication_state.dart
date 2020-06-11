abstract class AuthenticationState {
  const AuthenticationState();
}

class AuthenticatedState extends AuthenticationState {
  const AuthenticatedState();
}

class UnauthenticatedState extends AuthenticatedState {
  const UnauthenticatedState();
}
