part of 'likes_retweets_bloc.dart';

/// Loads the users and sets it to the [LikesRetweetsBloc.users];
abstract class LoadUsers extends LoadPaginatedData {
  const LoadUsers();

  /// Used to request the users from [LikesRetweetsBloc]
  Future<List<UserData?>> requestUsers(LikesRetweetsBloc bloc);

  @override
  Future<bool> loadData(PaginatedBloc paginatedBloc) async {
    final bloc = paginatedBloc as LikesRetweetsBloc;

    final users = await requestUsers(bloc);

    if (users.isEmpty) {
      return false;
    } else {
      bloc.users = users.map((user) => user!).toList();

      return true;
    }
  }
}
