import 'package:flutter/foundation.dart';

@immutable
abstract class FollowingState {}

/// The state while the following users are loading.
class LoadingFollowingState extends FollowingState {}

/// The state when following users has been loaded.
class LoadedFollowingState extends FollowingState {}

/// The state when an error occurred during loading the following users.
class FailedLoadingFollowingState extends FollowingState {}
