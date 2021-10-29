part of 'legacy_paginated_bloc.dart';

// TODO: remove and migrate to PaginatedCubitMixin

abstract class LegacyPaginatedEvent {
  const LegacyPaginatedEvent();

  Future<void> handle(LegacyPaginatedBloc bloc, Emitter emit);
}

/// An abstract event to load paginated data.
abstract class LoadPaginatedData extends LegacyPaginatedEvent with HarpyLogger {
  const LoadPaginatedData();

  /// Loads the data and returns `true` when the data was able to be loaded or
  /// `false` when an error occurred.
  Future<bool> loadData(LegacyPaginatedBloc paginatedBloc);

  /// Prevents successive requests for 30 seconds.
  void _lockRequests(LegacyPaginatedBloc bloc) {
    bloc.lockRequests = true;

    Future<void>.delayed(bloc.lockDuration).then(
      (_) => bloc.add(const UnlockRequests()),
    );
  }

  @override
  Future<void> handle(LegacyPaginatedBloc bloc, Emitter emit) async {
    if (bloc.lockRequests) {
      return;
    }

    log.fine('loading paginated data');

    if (bloc.cursor == null) {
      log.fine('no more data can be requested');
      return;
    }

    emit(LoadingPaginatedData());

    if (await loadData(bloc)) {
      emit(LoadedData());

      if (bloc.lockDuration != Duration.zero) {
        _lockRequests(bloc);
      }
    } else {
      emit(LoadingFailed());
    }

    bloc.loadDataCompleter.complete();
    bloc.loadDataCompleter = Completer<void>();
  }
}

/// An event to unlock the requests for the [LegacyPaginatedBloc].
class UnlockRequests extends LegacyPaginatedEvent with HarpyLogger {
  const UnlockRequests();

  @override
  Future<void> handle(LegacyPaginatedBloc bloc, Emitter emit) async {
    log.fine('unlocking request lock');

    bloc.lockRequests = false;

    emit(LoadedData());
  }
}
