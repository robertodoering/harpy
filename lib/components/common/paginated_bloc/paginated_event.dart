import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:harpy/components/common/paginated_bloc/paginated_bloc.dart';
import 'package:harpy/components/common/paginated_bloc/paginated_state.dart';
import 'package:logging/logging.dart';

@immutable
abstract class PaginatedEvent {
  const PaginatedEvent();

  Stream<PaginatedState> applyAsync({
    PaginatedState currentState,
    PaginatedBloc bloc,
  });
}

/// An abstract event to load paginated data.
abstract class LoadPaginatedData extends PaginatedEvent {
  const LoadPaginatedData();

  static final Logger _log = Logger('LoadPaginatedData');

  /// Loads the data and returns `true` when the data was able to be loaded or
  /// `false` when an error occurred.
  Future<bool> loadData(PaginatedBloc bloc);

  /// Prevents successive requests for 30 seconds.
  void _lockRequests(PaginatedBloc bloc) {
    bloc.lockRequests = true;

    Future<void>.delayed(const Duration(seconds: 0)).then(
      (_) => bloc.add(const UnlockRequests()),
    );
  }

  @override
  Stream<PaginatedState> applyAsync({
    PaginatedState currentState,
    PaginatedBloc bloc,
  }) async* {
    if (bloc.lockRequests) {
      return;
    }

    _log.fine('loading paginated data');

    if (bloc.cursor == null) {
      _log.fine('no more data can be requested');
      return;
    }

    yield LoadingPaginatedData();

    if (await loadData(bloc)) {
      yield LoadedData();
      _lockRequests(bloc);
    } else {
      yield LoadingFailed();
    }

    bloc.loadDataCompleter.complete();
    bloc.loadDataCompleter = Completer<void>();
  }
}

/// An event to unlock the requests for the [PaginatedBloc].
class UnlockRequests extends PaginatedEvent {
  const UnlockRequests();

  static final Logger _log = Logger('UnlockRequests');

  @override
  Stream<PaginatedState> applyAsync({
    PaginatedState currentState,
    PaginatedBloc bloc,
  }) async* {
    _log.fine('unlocking request lock');

    bloc.lockRequests = false;

    yield LoadedData();
  }
}
