import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/core/core.dart';

part 'paginated_notifier_mixin.freezed.dart';

/// Implements common functionality for notifiers that handle paginated
/// responses.
mixin PaginatedNotifierMixin<R, D>
    on StateNotifier<PaginatedState<D>>, RequestLock {
  @protected
  Future<R> request([int? cursor]);

  /// Used to handle the [response] for [loadInitial].
  ///
  /// Usually used to emit a [PaginatedState.data] with a cursor for the next
  /// page or a [PaginatedState.noData]
  @protected
  Future<void> onInitialResponse(R response);

  /// Used to handle the [response] for [loadMore].
  ///
  /// [data] is the data of the previous state.
  ///
  /// Usually used to emit a [PaginatedState.data] with the new data appended
  /// and a new cursor.
  @protected
  Future<void> onMoreResponse(R response, D data);

  @protected
  Future<void> onRequestError(Object error, StackTrace stackTrace);

  /// Loads the initial set of data and handles its response.
  ///
  /// This is used for the initialization and to refresh / reset the state.
  Future<void> loadInitial() async {
    state = const PaginatedState.loading();

    try {
      final response = await request();

      await onInitialResponse(response);
    } catch (e, st) {
      state = const PaginatedState.error();

      await onRequestError(e, st);
    }
  }

  /// Loads the "next page" of data and handles its response.
  ///
  /// Does nothing if no next page is available.
  Future<void> loadMore() async {
    if (lock()) return;

    if (state is PaginatedStateData<D> && state.canLoadMore) {
      final currentState = state as PaginatedStateData<D>;

      state = PaginatedState.loadingMore(data: currentState.data);

      try {
        final response = await request(currentState.cursor);

        await onMoreResponse(response, currentState.data);
      } catch (e, st) {
        state = const PaginatedState.error();
        await onRequestError(e, st);
      }
    }
  }
}

@freezed
class PaginatedState<T> with _$PaginatedState<T> {
  const factory PaginatedState.initial() = PaginatedStateInitial;
  const factory PaginatedState.loading() = PaginatedStateLoading;

  const factory PaginatedState.data({
    required T data,
    int? cursor,
  }) = PaginatedStateData;

  const factory PaginatedState.noData() = PaginatedStateNoData;

  const factory PaginatedState.loadingMore({
    required T data,
  }) = PaginatedStateLoadingMore;

  const factory PaginatedState.error() = PaginatedStateError;
}

extension PaginatedStateExtension<T> on PaginatedState<T> {
  T? get data => mapOrNull(
        data: (value) => value.data,
        loadingMore: (value) => value.data,
      );

  bool get canLoadMore => maybeMap(
        data: (value) => value.cursor != null && value.cursor != 0,
        orElse: () => false,
      );
}
