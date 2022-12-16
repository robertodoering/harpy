import 'package:built_collection/built_collection.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/core/core.dart';
import 'package:rby/rby.dart';

part 'list_show_provider.freezed.dart';

final listShowProvider = StateNotifierProvider.autoDispose
    .family<ListShowNotifier, ListShowState, String>(
  (ref, handle) => ListShowNotifier(
    handle: handle,
    ref: ref,
    twitterApi: ref.watch(twitterApiV1Provider),
  ),
  name: 'ListShowProvider',
);

class ListShowNotifier extends StateNotifier<ListShowState> with LoggerMixin {
  ListShowNotifier({
    required String handle,
    required Ref ref,
    required TwitterApi twitterApi,
  })  : _handle = handle,
        _ref = ref,
        _twitterApi = twitterApi,
        super(const ListShowState.loading()) {
    load();
  }

  final String _handle;

  final Ref _ref;
  final TwitterApi _twitterApi;

  Future<void> load() async {
    log.fine('loading lists');

    state = const ListShowState.loading();

    PaginatedTwitterLists? paginatedOwnerships;
    PaginatedTwitterLists? paginatedSubscriptions;

    final responses = await Future.wait([
      _twitterApi.listsService.ownerships(screenName: _handle),
      _twitterApi.listsService.subscriptions(screenName: _handle),
    ]).handleError((e, st) => twitterErrorHandler(_ref, e, st));

    if (responses != null && responses.length == 2) {
      paginatedOwnerships = responses[0];
      paginatedSubscriptions = responses[1];
    }

    BuiltList<TwitterListData>? ownerships;
    BuiltList<TwitterListData>? subscriptions;
    String? ownershipsCursor;
    String? subscriptionsCursor;

    if (paginatedOwnerships != null) {
      ownerships =
          paginatedOwnerships.lists!.map(TwitterListData.fromV1).toBuiltList();

      ownershipsCursor = paginatedOwnerships.nextCursorStr;
    }

    if (paginatedSubscriptions != null) {
      subscriptions = paginatedSubscriptions.lists!
          .map(TwitterListData.fromV1)
          .toBuiltList();

      subscriptionsCursor = paginatedSubscriptions.nextCursorStr;
    }

    if (ownerships != null && subscriptions != null) {
      log.fine(
        'found ${ownerships.length} ownerships & '
        '${subscriptions.length} subscriptions',
      );

      if (ownerships.isNotEmpty || subscriptions.isNotEmpty) {
        state = ListShowState.data(
          ownerships: ownerships,
          subscriptions: subscriptions,
          ownershipsCursor: ownershipsCursor,
          subscriptionsCursor: subscriptionsCursor,
        );
      } else {
        state = const ListShowState.noData();
      }
    } else {
      state = const ListShowState.error();
    }
  }

  Future<void> loadMoreOwnerships() async {
    final currentState = state;

    if (currentState is _Data && currentState.hasMoreOwnerships) {
      state = ListShowState.loadingMoreOwnerships(
        ownerships: currentState.ownerships,
        subscriptions: currentState.subscriptions,
      );

      final paginatedOwnerships = await _twitterApi.listsService
          .ownerships(
            screenName: _handle,
            cursor: currentState.ownershipsCursor,
          )
          .handleError((e, st) => twitterErrorHandler(_ref, e, st));

      if (paginatedOwnerships != null) {
        final newOwnerships =
            paginatedOwnerships.lists!.map(TwitterListData.fromV1).toList();

        final ownerships =
            currentState.ownerships.followedBy(newOwnerships).toBuiltList();

        state = ListShowState.data(
          ownerships: ownerships,
          subscriptions: currentState.subscriptions,
          ownershipsCursor: paginatedOwnerships.nextCursorStr,
          subscriptionsCursor: currentState.subscriptionsCursor,
        );
      } else {
        state = ListShowState.data(
          ownerships: currentState.ownerships,
          subscriptions: currentState.subscriptions,
          ownershipsCursor: null,
          subscriptionsCursor: currentState.subscriptionsCursor,
        );
      }
    }
  }

  Future<void> loadMoreSubscriptions() async {
    final currentState = state;

    if (currentState is _Data && currentState.hasMoreSubscriptions) {
      state = ListShowState.loadingMoreSubscriptions(
        ownerships: currentState.ownerships,
        subscriptions: currentState.subscriptions,
      );

      final paginatedSubscriptions = await _twitterApi.listsService
          .subscriptions(
            screenName: _handle,
            cursor: currentState.subscriptionsCursor,
          )
          .handleError((e, st) => twitterErrorHandler(_ref, e, st));

      if (paginatedSubscriptions != null) {
        final newSubscriptions =
            paginatedSubscriptions.lists!.map(TwitterListData.fromV1);

        final subscriptions =
            state.subscriptions.followedBy(newSubscriptions).toBuiltList();

        state = ListShowState.data(
          ownerships: currentState.ownerships,
          subscriptions: subscriptions,
          ownershipsCursor: currentState.ownershipsCursor,
          subscriptionsCursor: paginatedSubscriptions.nextCursorStr,
        );
      } else {
        state = ListShowState.data(
          ownerships: currentState.ownerships,
          subscriptions: currentState.subscriptions,
          ownershipsCursor: currentState.ownershipsCursor,
          subscriptionsCursor: null,
        );
      }
    }
  }
}

@freezed
class ListShowState with _$ListShowState {
  const factory ListShowState.loading() = _Loading;

  const factory ListShowState.data({
    required BuiltList<TwitterListData> ownerships,
    required BuiltList<TwitterListData> subscriptions,
    required String? ownershipsCursor,
    required String? subscriptionsCursor,
  }) = _Data;

  const factory ListShowState.noData() = _NoData;

  const factory ListShowState.loadingMoreOwnerships({
    required BuiltList<TwitterListData> ownerships,
    required BuiltList<TwitterListData> subscriptions,
  }) = _LoadingMoreOwnerships;

  const factory ListShowState.loadingMoreSubscriptions({
    required BuiltList<TwitterListData> ownerships,
    required BuiltList<TwitterListData> subscriptions,
  }) = _LoadingMoreSubscriptions;

  const factory ListShowState.error() = _Error;
}

extension ListShowStateExtension on ListShowState {
  bool get loadingMoreOwnerships => this is _LoadingMoreOwnerships;
  bool get loadingMoreSubscriptions => this is _LoadingMoreSubscriptions;

  BuiltList<TwitterListData> get ownerships => maybeMap(
        data: (value) => value.ownerships,
        loadingMoreOwnerships: (value) => value.ownerships,
        loadingMoreSubscriptions: (value) => value.ownerships,
        orElse: BuiltList.new,
      );

  BuiltList<TwitterListData> get subscriptions => maybeMap(
        data: (value) => value.subscriptions,
        loadingMoreOwnerships: (value) => value.subscriptions,
        loadingMoreSubscriptions: (value) => value.subscriptions,
        orElse: BuiltList.new,
      );

  bool get hasMoreOwnerships => maybeMap(
        data: (value) => value.ownershipsCursor != '0',
        orElse: () => false,
      );

  bool get hasMoreSubscriptions => maybeMap(
        data: (value) => value.subscriptionsCursor != '0',
        orElse: () => false,
      );
}
