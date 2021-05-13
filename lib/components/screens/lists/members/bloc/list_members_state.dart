part of 'list_members_bloc.dart';

abstract class ListMembersState extends Equatable {
  const ListMembersState();
}

extension ListMembersStateExtension on ListMembersState {
  bool get isLoading => this is ListMembersInitialLoading;

  bool get hasResult => this is ListMembersResult || this is MembersLoadingMore;

  bool get hasMoreData => membersCursor != null && membersCursor != '0';

  bool get loadingMore => this is MembersLoadingMore;

  bool get isFailure => this is ListMembersFailure;

  bool get hasNoMembers => this is NoListMembersResult;

  String? get membersCursor {
    if (this is ListMembersResult) {
      return (this as ListMembersResult).membersCursor;
    } else if (this is MembersLoadingMore) {
      return (this as MembersLoadingMore).membersCursor;
    } else {
      return null;
    }
  }

  List<UserData> get members {
    if (this is ListMembersResult) {
      return (this as ListMembersResult).members;
    } else if (this is MembersLoadingMore) {
      return (this as MembersLoadingMore).members;
    } else {
      return <UserData>[];
    }
  }
}

class ListMembersInitialLoading extends ListMembersState {
  const ListMembersInitialLoading();

  @override
  List<Object> get props => <Object>[];
}

class ListMembersResult extends ListMembersState {
  const ListMembersResult({
    required this.members,
    required this.membersCursor,
  });

  final List<UserData> members;
  final String? membersCursor;

  @override
  List<Object?> get props => <Object?>[
        members,
        membersCursor,
      ];
}

class NoListMembersResult extends ListMembersState {
  const NoListMembersResult();

  @override
  List<Object?> get props => <Object>[];
}

class ListMembersFailure extends ListMembersState {
  const ListMembersFailure();

  @override
  List<Object?> get props => <Object>[];
}

class MembersLoadingMore extends ListMembersState {
  const MembersLoadingMore({
    required this.members,
    required this.membersCursor,
  });

  final List<UserData> members;
  final String? membersCursor;

  @override
  List<Object?> get props => <Object?>[
        members,
        membersCursor,
      ];
}
