import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/rby/rby.dart';

part 'trends_provider.freezed.dart';

final trendsProvider =
    StateNotifierProvider<TrendsProviderNotifier, AsyncValue<TrendsState>>(
  (ref) => TrendsProviderNotifier(
    read: ref.read,
    twitterApi: ref.watch(twitterApiProvider),
    userLocation: ref.watch(userTrendsLocationProvider),
  ),
  name: 'TrendsProvider',
);

class TrendsProviderNotifier extends StateNotifier<AsyncValue<TrendsState>>
    with LoggerMixin {
  TrendsProviderNotifier({
    required Reader read,
    required TwitterApi twitterApi,
    required TrendsLocationData userLocation,
  })  : _read = read,
        _twitterApi = twitterApi,
        _trendsLocationData = userLocation,
        super(const AsyncValue.loading()) {
    load();
  }

  final Reader _read;
  final TwitterApi _twitterApi;
  final TrendsLocationData _trendsLocationData;

  Future<void> load() async {
    log.fine('finding trends for ${_trendsLocationData.name}');

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () async {
        final trends = await _twitterApi.trendsService
            .place(id: _trendsLocationData.woeid)
            .then((trends) => trends.first.trends ?? <Trend>[])
            .then(
              (trends) => trends
                ..sort(
                  (o1, o2) => (o2.tweetVolume ?? 0) - (o1.tweetVolume ?? 0),
                ),
            );

        return TrendsState(trends: trends.toBuiltList());
      },
    );
  }

  Future<void> updateLocation({
    required TrendsLocationData location,
  }) async {
    log.fine('updating trends location');

    try {
      _read(trendsLocationPreferencesProvider.notifier).setTrendsLocationData(
        jsonEncode(location.toJson()),
      );
    } catch (e, st) {
      log.severe('unable to update trends location', e, st);
    }
  }
}

@freezed
class TrendsState with _$TrendsState {
  factory TrendsState({
    required BuiltList<Trend> trends,
  }) = _TrendsState;

  TrendsState._();

  // late final BuiltList<Trend> hashtags = trends
  //     .where((trend) => trend.name?.startsWith('#') ?? false)
  //     .toBuiltList();
}

// extension TrendsStateExtension on TrendsState {
//   TrendsLocationData? get location => mapOrNull(
//         data: (value) => value.location,
//         loading: (value) => value.location,
//         error: (value) => value.location,
//       );

//   String get locationName {
//     if (location != null) {
//       return location!.woeid == 1
//           ? 'worldwide trends'
//           : 'trends in ${location!.name}';
//     } else {
//       return 'trends';
//     }
//   }

//   BuiltList<Trend> get hashtags => maybeMap(
//         data: (value) => value.hashtags,
//         orElse: BuiltList.new,
//       );
// }
