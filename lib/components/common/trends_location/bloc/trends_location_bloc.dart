import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/core/core.dart';

part 'trends_location_event.dart';
part 'trends_location_state.dart';

/// Handles loading locations that can be used to request local trends.
class TrendsLocationBloc
    extends Bloc<TrendsLocationEvent, TrendsLocationState> {
  TrendsLocationBloc() : super(const TrendsLocationNotLoaded());

  final TrendsService trendsService = app<TwitterApi>().trendsService;

  @override
  Stream<TrendsLocationState> mapEventToState(
    TrendsLocationEvent event,
  ) async* {
    yield* event.applyAsync(currentState: state, bloc: this);
  }
}
