import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:equatable/equatable.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:location/location.dart' as location;

part 'find_trends_locations_event.dart';
part 'find_trends_locations_state.dart';

/// Handles finding trends locations that are available close to provided
/// coordinates.
class FindTrendsLocationsBloc
    extends Bloc<FindTrendsLocationsEvent, FindTrendsLocationsState> {
  FindTrendsLocationsBloc() : super(const FindTrendsLocationsInitial());

  final TrendsService trendsService = app<TwitterApi>().trendsService;

  @override
  Stream<FindTrendsLocationsState> mapEventToState(
    FindTrendsLocationsEvent event,
  ) async* {
    yield* event.applyAsync(currentState: state, bloc: this);
  }
}
