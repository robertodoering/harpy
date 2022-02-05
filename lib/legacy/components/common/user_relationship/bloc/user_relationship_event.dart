part of 'user_relationship_bloc.dart';

abstract class UserRelationshipEvent {
  const UserRelationshipEvent();

  const factory UserRelationshipEvent.load() = _Load;
  const factory UserRelationshipEvent.follow() = _Follow;
  const factory UserRelationshipEvent.unfollow() = _Unfollow;

  Future<void> handle(UserRelationshipBloc bloc, Emitter emit);
}

class _Load extends UserRelationshipEvent {
  const _Load();

  @override
  Future<void> handle(UserRelationshipBloc bloc, Emitter emit) async {
    emit(const UserRelationshipState.loading());

    final connections = await app<TwitterApi>()
        .userService
        .friendshipsLookup(screenNames: [bloc._handle])
        .then((response) => response.length == 1 ? response.first : null)
        .then((friendship) => friendship?.connections?.toBuiltSet())
        .handleError(silentErrorHandler);

    if (connections != null) {
      emit(UserRelationshipState.data(connections: connections));
    } else {
      emit(const UserRelationshipState.error());
    }
  }
}

class _Follow extends UserRelationshipEvent with HarpyLogger {
  const _Follow();

  @override
  Future<void> handle(UserRelationshipBloc bloc, Emitter emit) async {
    final initialState = bloc.state;

    if (initialState is _Data) {
      log.fine('following @#${bloc._handle}');

      // immediately assume following
      emit(
        initialState.copyWith(
          connections:
              (initialState.connections.toSet()..add('following')).toBuiltSet(),
        ),
      );

      await app<TwitterApi>()
          .userService
          .friendshipsCreate(screenName: bloc._handle)
          .then((_) => log.fine('successfully followed @${bloc._handle}'))
          .handleError((dynamic e, st) {
        twitterApiErrorHandler(e, st);

        // assume still not following
        // re-emit initial state
        emit(initialState);
      });
    }
  }
}

class _Unfollow extends UserRelationshipEvent with HarpyLogger {
  const _Unfollow();

  @override
  Future<void> handle(UserRelationshipBloc bloc, Emitter emit) async {
    final initialState = bloc.state;

    if (initialState is _Data) {
      log.fine('un-following @#${bloc._handle}');

      // immediately assume un-followed
      emit(
        initialState.copyWith(
          connections: (initialState.connections.toSet()..remove('following'))
              .toBuiltSet(),
        ),
      );

      await app<TwitterApi>()
          .userService
          .friendshipsDestroy(screenName: bloc._handle)
          .then((_) => log.fine('successfully un-followed @${bloc._handle}'))
          .handleError((dynamic e, st) {
        twitterApiErrorHandler(e, st);

        // assume still following
        // re-emit initial state
        emit(initialState);
      });
    }
  }
}
