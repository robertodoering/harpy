import 'package:built_collection/built_collection.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/rby/rby.dart';

/// Provides the [UserConnection] for a list of users.
///
/// Connections are mapped to the user handle.
final userConnectionsProvider = StateNotifierProvider.autoDispose.family<
    UserConnectionsNotifier,
    BuiltMap<String, BuiltSet<UserConnection>>,
    BuiltList<String>>(
  (ref, handles) => UserConnectionsNotifier(
    ref: ref,
    handles: handles,
    twitterApi: ref.watch(twitterApiProvider),
  ),
  name: 'UserConnectionsProvider',
);

class UserConnectionsNotifier
    extends StateNotifier<BuiltMap<String, BuiltSet<UserConnection>>>
    with LoggerMixin {
  UserConnectionsNotifier({
    required Ref ref,
    required BuiltList<String> handles,
    required TwitterApi twitterApi,
  })  : assert(handles.isNotEmpty),
        _ref = ref,
        _handles = handles,
        _twitterApi = twitterApi,
        super(BuiltMap());

  final Ref _ref;
  final BuiltList<String> _handles;
  final TwitterApi _twitterApi;

  Future<void> load() async {
    state = await _twitterApi.userService
        .friendshipsLookup(screenNames: _handles.toList())
        .then(_mapConnections)
        .handleError(logErrorHandler)
        .then((value) => value ?? BuiltMap<String, BuiltSet<UserConnection>>());
  }

  Future<void> follow(String handle) async {
    log.fine('follow $handle');

    state = state.rebuild(
      (builder) => builder[handle] = _addOrCreateConnection(
        builder[handle],
        UserConnection.following,
      ),
    );

    await _twitterApi.userService
        .friendshipsCreate(screenName: handle)
        .handleError((e, st) {
      twitterErrorHandler(_ref, e, st);
      if (!mounted) return;

      // assume still not following
      state = state.rebuild(
        (builder) => builder[handle] = _removeOrCreateConnection(
          builder[handle],
          UserConnection.following,
        ),
      );
    });
  }

  Future<void> unfollow(String handle) async {
    log.fine('unfollow $handle');

    state = state.rebuild(
      (builder) => builder[handle] = _removeOrCreateConnection(
        builder[handle],
        UserConnection.following,
      ),
    );

    await _twitterApi.userService
        .friendshipsDestroy(screenName: handle)
        .handleError((e, st) {
      twitterErrorHandler(_ref, e, st);
      if (!mounted) return;

      // assume still following
      state = state.rebuild(
        (builder) => builder[handle] = _addOrCreateConnection(
          builder[handle],
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
    if (friendship.screenName != null) {
      final connections = <UserConnection>{};

      if (friendship.connections != null) {
        connections.addAll(friendship.connections!.map(parseUserConnection));
      }

      mappedConnections[friendship.screenName!] = connections.toBuiltSet();
    }
  }

  return BuiltMap(mappedConnections);
}
