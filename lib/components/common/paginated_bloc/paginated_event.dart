part of 'paginated_bloc.dart';

abstract class PaginatedEvent {
  const PaginatedEvent();

  Future<void> handle(PaginatedBloc bloc, Emitter emit);
}

/// An abstract event to load paginated data.
abstract class LoadPaginatedData extends PaginatedEvent with HarpyLogger {
  const LoadPaginatedData();

  /// Loads the data and returns `true` when the data was able to be loaded or
  /// `false` when an error occurred.
  Future<bool> loadData(PaginatedBloc paginatedBloc);

  /// Prevents successive requests for 30 seconds.
  void _lockRequests(PaginatedBloc bloc) {
    bloc.lockRequests = true;

    Future<void>.delayed(bloc.lockDuration).then(
      (_) => bloc.add(const UnlockRequests()),
    );
  }

  @override
  Future<void> handle(PaginatedBloc bloc, Emitter emit) async {
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

/// An event to unlock the requests for the [PaginatedBloc].
class UnlockRequests extends PaginatedEvent with HarpyLogger {
  const UnlockRequests();

  @override
  Future<void> handle(PaginatedBloc bloc, Emitter emit) async {
    log.fine('unlocking request lock');

    bloc.lockRequests = false;

    emit(LoadedData());
  }
}
