import 'package:built_collection/built_collection.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:rby/rby.dart';

/// Provides the [LegacyUserConnection] for a list of users.
///
/// Connections are mapped to the user handle.
final legacyUserConnectionsProvider = StateNotifierProvider.autoDispose.family<
    LegacyUserConnectionsNotifier,
    BuiltMap<String, BuiltSet<LegacyUserConnection>>,
    BuiltList<String>>(
  (ref, handles) => LegacyUserConnectionsNotifier(
    ref: ref,
    handles: handles,
    twitterApi: ref.watch(twitterApiV1Provider),
  ),
  name: 'UserConnectionsProvider',
);

class LegacyUserConnectionsNotifier
    extends StateNotifier<BuiltMap<String, BuiltSet<LegacyUserConnection>>>
    with LoggerMixin {
  LegacyUserConnectionsNotifier({
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
        .then(
          (value) =>
              value ?? BuiltMap<String, BuiltSet<LegacyUserConnection>>(),
        );
  }

  Future<void> follow(String handle) async {
    log.fine('follow $handle');

    state = state.rebuild(
      (builder) => builder[handle] = _addOrCreateConnection(
        builder[handle],
        LegacyUserConnection.following,
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
          LegacyUserConnection.following,
        ),
      );
    });
  }

  Future<void> unfollow(String handle) async {
    log.fine('unfollow $handle');

    state = state.rebuild(
      (builder) => builder[handle] = _removeOrCreateConnection(
        builder[handle],
        LegacyUserConnection.following,
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
          LegacyUserConnection.following,
        ),
      );
    });
  }
}

BuiltSet<LegacyUserConnection> _addOrCreateConnection(
  BuiltSet<LegacyUserConnection>? connections,
  LegacyUserConnection connection,
) {
  return connections?.rebuild(
        (builder) => builder.add(connection),
      ) ??
      {connection}.toBuiltSet();
}

BuiltSet<LegacyUserConnection> _removeOrCreateConnection(
  BuiltSet<LegacyUserConnection>? connections,
  LegacyUserConnection connection,
) {
  return connections?.rebuild((builder) => builder.remove(connection)) ??
      BuiltSet();
}

BuiltMap<String, BuiltSet<LegacyUserConnection>> _mapConnections(
  List<Friendship> friendships,
) {
  final mappedConnections = <String, BuiltSet<LegacyUserConnection>>{};

  for (final friendship in friendships) {
    if (friendship.screenName != null) {
      final connections = <LegacyUserConnection>{};

      if (friendship.connections != null) {
        connections.addAll(friendship.connections!.map(parseUserConnection));
      }

      mappedConnections[friendship.screenName!] = connections.toBuiltSet();
    }
  }

  return BuiltMap(mappedConnections);
}
