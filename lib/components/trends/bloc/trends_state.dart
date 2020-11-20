import 'package:flutter/foundation.dart';

@immutable
abstract class TrendsState {}

class InitialTrendsState extends TrendsState {}

/// The state when trends are currently being requested.
class RequestingTrendsState extends TrendsState {}

class UpdatedTrendsState extends TrendsState {}
