import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

/// Implements common functionality for cubits that handle paginated responses.
mixin PaginatedCubitMixin<Response, Data>
    on Cubit<PaginatedState<Data>>, RequestLock {
  @protected
  Future<Response> request([int? cursor]);

  /// Used to handle the [response] for [loadInitial].
  ///
  /// Usually used to emit a [PaginatedState.data] with a cursor for the next
  /// page or a [PaginatedState.noData]
  @protected
  Future<void> onInitialResponse(Response response);

  /// Used to handle the [response] for [loadMore].
  ///
  /// [data] is the data of the previous state.
  ///
  /// Usually used to emit a [PaginatedState.data] with the new data appended
  /// and a new cursor.
  @protected
  Future<void> onMoreResponse(Response response, Data data);

  @protected
  Future<void> onRequestError(Object error, StackTrace stackTrace) async =>
      twitterApiErrorHandler(error, stackTrace);

  /// Loads the initial set of data and handles its response.
  ///
  /// This is used for the initialization and to refresh / reset the state.
  Future<void> loadInitial() async {
    emit(const PaginatedState.loading());

    try {
      final response = await request();

      await onInitialResponse(response);
    } catch (e, st) {
      emit(const PaginatedState.error());

      await onRequestError(e, st);
    }
  }

  /// Loads the "next page" of data and handles its response.
  ///
  /// Does nothing if no next page is available.
  Future<void> loadMore() async {
    if (lock()) {
      return;
    }

    if (state is PaginatedStateData && state.canLoadMore) {
      final currentState = state as PaginatedStateData;

      emit(PaginatedState.loadingMore(data: currentState.data));

      try {
        final response = await request(currentState.cursor);

        await onMoreResponse(response, currentState.data);
      } catch (e, st) {
        emit(const PaginatedState.error());
        await onRequestError(e, st);
      }
    }
  }
}
