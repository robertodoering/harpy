import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:equatable/equatable.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

part 'trends_locations_event.dart';
part 'trends_locations_state.dart';

/// Handles loading locations that can be used to request local trends.
class TrendsLocationsBloc
    extends Bloc<TrendsLocationsEvent, TrendsLocationsState> with HarpyLogger {
  TrendsLocationsBloc() : super(const TrendsLocationsNotLoaded());

  final TrendsService trendsService = app<TwitterApi>().trendsService;

  @override
  Stream<TrendsLocationsState> mapEventToState(
    TrendsLocationsEvent event,
  ) async* {
    yield* event.applyAsync(currentState: state, bloc: this);
  }
}
