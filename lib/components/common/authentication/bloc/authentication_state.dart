part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationState {}

/// The state when the user has been authenticated.
///
/// [AuthenticationBloc.twitterAuthSession] must not be `null` when the user is
/// authenticated.
class AuthenticatedState extends AuthenticationState {}

/// The state when the user is currently attempting to authenticate.
class AwaitingAuthenticationState extends AuthenticationState {}

/// The state when the user has not yet been authenticated.
class UnauthenticatedState extends AuthenticationState {}
