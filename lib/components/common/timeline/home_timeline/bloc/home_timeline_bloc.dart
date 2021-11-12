import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:built_collection/built_collection.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

part 'home_timeline_bloc.freezed.dart';
part 'home_timeline_event.dart';

class HomeTimelineBloc extends Bloc<HomeTimelineEvent, HomeTimelineState>
    with RequestLock {
  HomeTimelineBloc() : super(const HomeTimelineState.initial()) {
    on<HomeTimelineEvent>((event, emit) => event.handle(this, emit));
  }

  TimelineFilter get filter => TimelineFilter.fromJsonString(
        app<TimelineFilterPreferences>().homeTimelineFilter,
      );

  /// Completes when the home timeline has been refreshed using the
  /// [HomeTimelineEvent.load] event.
  Completer<void> refreshCompleter = Completer<void>();

  /// Completes when older tweets for the timeline have been requested using
  /// [HomeTimelineEvent.loadOlder].
  Completer<void> requestOlderCompleter = Completer<void>();
}

@freezed
class HomeTimelineState with _$HomeTimelineState {
  const factory HomeTimelineState.initial() = _Initial;

  const factory HomeTimelineState.loading() = _Loading;

  const factory HomeTimelineState.data({
    required BuiltList<TweetData> tweets,

    /// The max id used to request older tweets.
    ///
    /// This is the id of the last requested tweet before the tweets got
    /// filtered.
    required String? maxId,

    /// The idStr of that last tweet from the initial request.
    String? initialResultsLastId,

    /// The number of new tweets if the initial request found new tweets that
    /// were not present in a previous session.
    int? initialResultsCount,

    /// Whether we requested the initial home timeline with tweets that are
    /// newer than the last visible tweet from a previous session.
    @Default(false) bool isInitialResult,
  }) = _Data;

  const factory HomeTimelineState.noData() = _NoData;

  const factory HomeTimelineState.loadingOlder({
    required _Data data,
  }) = _LoadingOlder;

  const factory HomeTimelineState.error() = _Error;
}

extension HomeTimelineExtension on HomeTimelineState {
  bool get isLoading => this is _Loading;
  bool get isLoadingOlder => this is _LoadingOlder;

  bool get hasTweets => tweets.isNotEmpty;

  bool get canRequestOlder => maybeMap(
        data: (value) => value.maxId != null && value.maxId != '0',
        orElse: () => false,
      );

  BuiltList<TweetData> get tweets => maybeMap(
        data: (value) => value.tweets,
        loadingOlder: (value) => value.data.tweets,
        orElse: () => BuiltList(),
      );

  int get initialResultsCount => maybeMap(
        data: (value) => value.initialResultsCount ?? 0,
        loadingOlder: (value) => value.data.initialResultsCount ?? 0,
        orElse: () => 0,
      );

  bool showNewTweetsExist(String? originalIdStr) => maybeMap(
        data: (value) => value.initialResultsLastId == originalIdStr,
        loadingOlder: (value) =>
            value.data.initialResultsLastId == originalIdStr,
        orElse: () => false,
      );

  bool get scrollToEnd => maybeMap(
        data: (value) =>
            value.isInitialResult &&
            value.initialResultsCount != 0 &&
            value.initialResultsCount! > 0,
        orElse: () => false,
      );
}
