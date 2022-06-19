import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/rby/rby.dart';

final trendsProvider = StateNotifierProvider.autoDispose<TrendsNotifier,
    AsyncValue<BuiltList<Trend>>>(
  (ref) => TrendsNotifier(
    read: ref.read,
    twitterApi: ref.watch(twitterApiProvider),
    userLocation: ref.watch(userTrendsLocationProvider),
  ),
  cacheTime: const Duration(minutes: 5),
  name: 'TrendsProvider',
);

class TrendsNotifier extends StateNotifier<AsyncValue<BuiltList<Trend>>>
    with LoggerMixin {
  TrendsNotifier({
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

        return trends.toBuiltList();
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
