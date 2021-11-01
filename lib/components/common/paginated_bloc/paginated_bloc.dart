import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/core/core.dart';

part 'paginated_event.dart';
part 'paginated_state.dart';

/// An abstract bloc for loading data from paginated twitter requests with the
/// twitter api.
abstract class PaginatedBloc extends Bloc<PaginatedEvent, PaginatedState> {
  PaginatedBloc() : super(InitialPaginatedState()) {
    on<PaginatedEvent>((event, emit) => event.handle(this, emit));
  }

  /// Whether data has been loaded.
  bool get hasData;

  /// The duration requests should be locked for.
  Duration get lockDuration => const Duration(seconds: 30);

  /// The cursor for the paginated requests.
  ///
  /// When `-1`, the first page will be requested.
  /// When `0`, all pages have been requested.
  int? cursor = -1;

  /// Whether requests are locked.
  bool lockRequests = false;

  /// Completes when the [LoadPaginatedData] event completed.
  Completer<void> loadDataCompleter = Completer<void>();

  /// Whether more data can be loaded.
  bool get hasNextPage => cursor != 0;

  /// Whether more data should be loaded when scrolling to the end of the list.
  bool get canLoadMore =>
      !lockRequests && hasData && state is LoadedData && hasNextPage;

  /// Whether the initial data is being loaded.
  bool get loadingInitialData => !hasData && state is LoadingPaginatedData;

  /// Whether the next page of data is being loaded.
  bool get showLoadingMore => hasData && state is LoadingPaginatedData;

  /// Whether no data exists.
  bool get showNoDataExists => !hasData && state is LoadedData;

  /// Whether to show an error message.
  bool get showError => state is LoadingFailed;
}
