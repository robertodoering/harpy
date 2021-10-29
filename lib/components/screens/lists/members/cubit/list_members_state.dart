part of 'list_members_cubit.dart';

@freezed
class ListMembersState with _$ListMembersState {
  const factory ListMembersState.data({
    required BuiltList<UserData> members,
    required String? membersCursor,
  }) = _ListMembersStateData;

  const factory ListMembersState.loadingMore({
    required BuiltList<UserData> members,
  }) = _ListMembersStateLoadingMore;

  const factory ListMembersState.loading() = _ListMembersStateLoading;
  const factory ListMembersState.error() = _ListMembersStateError;
  const factory ListMembersState.noData() = _ListMembersStateNoData;
}

extension ListMembersDataExtension on ListMembersState {
  BuiltList<UserData> get members => maybeMap(
        data: (state) => state.members,
        loadingMore: (state) => state.members,
        orElse: () => BuiltList(),
      );

  bool get hasMoreData => maybeMap(
        data: (state) =>
            state.membersCursor != null && state.membersCursor != '0',
        orElse: () => false,
      );
}
