part of 'authentication_cubit.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
}

extension AuthenticationStateExtension on AuthenticationState {
  UserData? get user =>
      this is Authenticated ? (this as Authenticated).authenticatedUser : null;

  String get userId => this is Authenticated
      ? (this as Authenticated).twitterAuthSession.userId
      : '0';
}

class Unauthenticated extends AuthenticationState {
  const Unauthenticated();

  @override
  List<Object?> get props => [];
}

class AwaitingAuthentication extends AuthenticationState {
  const AwaitingAuthentication();

  @override
  List<Object?> get props => [];
}

class Authenticated extends AuthenticationState {
  const Authenticated({
    required this.twitterAuthSession,
    required this.authenticatedUser,
  });

  final TwitterAuthSession twitterAuthSession;
  final UserData authenticatedUser;

  @override
  List<Object?> get props => [
        twitterAuthSession,
        authenticatedUser,
      ];
}
