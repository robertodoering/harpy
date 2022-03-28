import 'package:built_collection/built_collection.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/rby/rby.dart';

/// Provides the [UserConnection] for a list of users.
///
/// Connections are mapped to the user id.
final userConnectionsProvider = StateNotifierProvider.autoDispose.family<
    UserConnectionsNotifier,
    BuiltMap<String, BuiltSet<UserConnection>>,
    BuiltList<String>>(
  (ref, handles) => UserConnectionsNotifier(
    handles: handles,
    read: ref.read,
    twitterApi: ref.watch(twitterApiProvider),
  ),
  name: 'UserConnectionsProvider',
);

class UserConnectionsNotifier
    extends StateNotifier<BuiltMap<String, BuiltSet<UserConnection>>>
    with LoggerMixin {
  UserConnectionsNotifier({
    required BuiltList<String> handles,
    required Reader read,
    required TwitterApi twitterApi,
  })  : assert(handles.isNotEmpty),
        _handles = handles,
        _read = read,
        _twitterApi = twitterApi,
        super(BuiltMap());

  final BuiltList<String> _handles;
  final Reader _read;
  final TwitterApi _twitterApi;

  Future<void> load() async {
    state = await _twitterApi.userService
        .friendshipsLookup(screenNames: _handles.toList())
        .then(_mapConnections)
        .catchError((dynamic e, dynamic st) {
      logErrorHandler(e, st);
      return BuiltMap<String, BuiltSet<UserConnection>>();
    });
  }

  Future<void> follow(String userId) async {
    log.fine('follow $userId');

    state = state.rebuild(
      (builder) => builder[userId] = _addOrCreateConnection(
        builder[userId],
        UserConnection.following,
      ),
    );

    await _twitterApi.userService
        .friendshipsCreate(userId: userId)
        .handleError((dynamic e, st) {
      twitterErrorHandler(_read, e, st);
      if (!mounted) return;

      // assume still not following
      state = state.rebuild(
        (builder) => builder[userId] = _removeOrCreateConnection(
          builder[userId],
          UserConnection.following,
        ),
      );
    });
  }

  Future<void> unfollow(String userId) async {
    log.fine('unfollow $userId');

    state = state.rebuild(
      (builder) => builder[userId] = _removeOrCreateConnection(
        builder[userId],
        UserConnection.following,
      ),
    );

    await _twitterApi.userService
        .friendshipsDestroy(userId: userId)
        .handleError((dynamic e, st) {
      twitterErrorHandler(_read, e, st);
      if (!mounted) return;

      // assume still following
      state = state.rebuild(
        (builder) => builder[userId] = _addOrCreateConnection(
          builder[userId],
          UserConnection.following,
        ),
      );
    });
  }
}

BuiltSet<UserConnection> _addOrCreateConnection(
  BuiltSet<UserConnection>? connections,
  UserConnection connection,
) {
  return connections?.rebuild(
        (builder) => builder.add(connection),
      ) ??
      {connection}.toBuiltSet();
}

BuiltSet<UserConnection> _removeOrCreateConnection(
  BuiltSet<UserConnection>? connections,
  UserConnection connection,
) {
  return connections?.rebuild((builder) => builder.remove(connection)) ??
      BuiltSet();
}

BuiltMap<String, BuiltSet<UserConnection>> _mapConnections(
  List<Friendship> friendships,
) {
  final mappedConnections = <String, BuiltSet<UserConnection>>{};

  for (final friendship in friendships) {
    if (friendship.idStr != null) {
      final connections = <UserConnection>{};

      if (friendship.connections != null) {
        connections.addAll(friendship.connections!.map(parseUserConnection));
      }

      mappedConnections[friendship.idStr!] = connections.toBuiltSet();
    }
  }

  return BuiltMap(mappedConnections);
}
