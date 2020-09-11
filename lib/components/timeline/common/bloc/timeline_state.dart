import 'package:flutter/foundation.dart';

@immutable
abstract class TimelineState {}

class UninitializedState extends TimelineState {}

/// The state when the timeline is currently requesting tweets.
class UpdatingTimelineState extends TimelineState {}

/// The state when the timeline is showing with tweets.
class ShowingTimelineState extends TimelineState {}

/// The state when the timeline is requesting more tweets.
class RequestingMoreState extends TimelineState {}

/// The state when the timeline does not return any tweets.
class NoTweetsFoundState extends TimelineState {}

/// The state when the timeline request failed.
class FailedLoadingTimelineState extends TimelineState {}
