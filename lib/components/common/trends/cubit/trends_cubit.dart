import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:built_collection/built_collection.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

part 'trends_cubit.freezed.dart';

class TrendsCubit extends Cubit<TrendsState> with HarpyLogger {
  TrendsCubit() : super(const TrendsState.initial());

  Future<void> findTrends() async {
    final location = TrendsLocationData.fromPreferences();

    log.fine('finding trends for ${location.name}');

    emit(TrendsState.loading(location: location));

    final trends = await app<TwitterApi>()
        .trendsService
        .place(id: location.woeid)
        .then((trends) => trends.first.trends)
        .handleError(silentErrorHandler);

    if (trends != null) {
      final sortedTrends = trends
        ..sort((o1, o2) => (o2.tweetVolume ?? 0) - (o1.tweetVolume ?? 0));

      emit(
        TrendsState.data(
          woeid: 1,
          trends: sortedTrends.toBuiltList(),
          hashtags: sortedTrends
              .where((trend) => trend.name!.startsWith('#'))
              .toBuiltList(),
          location: location,
        ),
      );
    } else {
      emit(TrendsState.error(location: location));
    }
  }

  Future<void> updateLocation({
    required TrendsLocationData location,
  }) async {
    log.fine('updating trends location');

    try {
      app<TrendsPreferences>().trendsLocation = jsonEncode(location.toJson());
      await findTrends();
    } catch (e, st) {
      log.severe('unable to update trends location', e, st);
    }
  }
}

@freezed
class TrendsState with _$TrendsState {
  const factory TrendsState.initial() = _Initial;

  const factory TrendsState.loading({
    /// The location used to request trends with.
    required TrendsLocationData location,
  }) = _Loading;

  const factory TrendsState.data({
    required int woeid,
    required BuiltList<Trend> trends,
    required BuiltList<Trend> hashtags,

    /// The location used to request trends with.
    required TrendsLocationData location,
  }) = _Data;

  const factory TrendsState.error({
    /// The location used to request trends with.
    required TrendsLocationData location,
  }) = _Error;
}

extension TrendsStateExtension on TrendsState {
  bool get isLoading => this is _Loading;
  bool get hasData => this is _Data;
  bool get isInitial => this is _Initial;

  TrendsLocationData? get location => mapOrNull(
        data: (value) => value.location,
        loading: (value) => value.location,
        error: (value) => value.location,
      );

  String get locationName {
    if (location != null) {
      if (location == TrendsLocationData.worldwide) {
        return 'worldwide trends';
      } else {
        return 'trends in ${location!.name}';
      }
    } else {
      return 'trends';
    }
  }

  BuiltList<Trend> get hashtags => maybeMap(
        data: (value) => value.hashtags,
        orElse: BuiltList.new,
      );
}
