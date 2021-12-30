import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:built_collection/built_collection.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

part 'trends_locations_cubit.freezed.dart';

/// Handles loading locations that can be used to request local trends.
class TrendsLocationsCubit extends Cubit<TrendsLocationsState>
    with HarpyLogger {
  TrendsLocationsCubit() : super(const TrendsLocationsState.initial());

  /// Loads the available trend locations which can be used to request local
  /// trends.
  ///
  /// Only countries are saved in the state.
  Future<void> load() async {
    log.fine('loading trends locations');

    emit(const TrendsLocationsState.loading());

    final trendsLocation = await app<TwitterApi>()
        .trendsService
        .available()
        .handleError(silentErrorHandler);

    if (trendsLocation != null) {
      final locations = <TrendsLocationData>[];

      // get all countries
      for (final location in trendsLocation
          .where((location) => location.placeType?.code == 12)) {
        if (location.woeid != null &&
            location.name != null &&
            location.placeType?.name != null) {
          locations.add(
            TrendsLocationData(
              woeid: location.woeid!,
              name: location.name!,
              placeType: location.placeType!.name!,
              country: location.country ?? '',
            ),
          );
        }
      }

      if (locations.isNotEmpty) {
        locations.sort((a, b) => a.name.compareTo(b.name));

        log.fine('found ${locations.length} trends locations');

        emit(TrendsLocationsState.data(locations: locations.toBuiltList()));
      } else {
        log.fine('found no trends locations');

        emit(const TrendsLocationsState.noData());
      }
    } else {
      log.info('error finding trends locations');

      emit(const TrendsLocationsState.error());
    }
  }
}

@freezed
class TrendsLocationsState with _$TrendsLocationsState {
  const factory TrendsLocationsState.initial() = _Initial;
  const factory TrendsLocationsState.loading() = _Loading;

  const factory TrendsLocationsState.data({
    required BuiltList<TrendsLocationData> locations,
  }) = _Data;

  const factory TrendsLocationsState.noData() = _NoData;
  const factory TrendsLocationsState.error() = _Error;
}

extension TrendsLocationsStateExtension on TrendsLocationsState {
  bool get hasData => this is _Data;

  BuiltList<TrendsLocationData> get locations => maybeWhen(
        data: (locations) => locations,
        orElse: BuiltList.new,
      );
}
