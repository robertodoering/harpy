import 'package:flutter/foundation.dart';

@immutable
abstract class RepliesState {}

/// The state when replies are currently being loaded.
class LoadingRepliesState extends RepliesState {}

/// The state when replies have been loaded.
class LoadedRepliesState extends RepliesState {}
