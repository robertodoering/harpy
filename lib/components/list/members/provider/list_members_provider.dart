import 'package:built_collection/built_collection.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

final listMembersProvider = StateNotifierProvider.autoDispose
    .family<ListsMembersNotifier, PaginatedState<BuiltList<UserData>>, String>(
  (ref, listId) => ListsMembersNotifier(
    ref: ref,
    twitterApi: ref.watch(twitterApiV1Provider),
    listId: listId,
  ),
  name: 'ListMembersProvider',
);

class ListsMembersNotifier extends PaginatedUsersNotifier {
  ListsMembersNotifier({
    required Ref ref,
    required TwitterApi twitterApi,
    required String listId,
  })  : _ref = ref,
        _twitterApi = twitterApi,
        _listId = listId,
        super(const PaginatedState.loading()) {
    loadInitial();
  }

  final Ref _ref;
  final TwitterApi _twitterApi;
  final String _listId;

  @override
  Future<void> onRequestError(Object error, StackTrace stackTrace) async =>
      twitterErrorHandler(_ref, error, stackTrace);

  @override
  Future<PaginatedUsers> request([int? cursor]) {
    return _twitterApi.listsService.members(
      listId: _listId,
      cursor: cursor?.toString(),
      skipStatus: true,
      count: 200,
    );
  }
}
