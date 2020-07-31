import 'package:flutter/foundation.dart';

@immutable
abstract class TimelineState {}

class UninitializedState extends TimelineState {}

class ShowingTimelineState extends TimelineState {}
