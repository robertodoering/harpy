import 'package:flutter/foundation.dart';

@immutable
abstract class UserProfileState {}

/// The state when a user is currently being loaded.
class LoadingUserState extends UserProfileState {}

/// The state when a user has been loaded.
class InitializedUserState extends UserProfileState {}

/// The state when a user was unable to be loaded.
class FailedLoadingUserState extends UserProfileState {}
