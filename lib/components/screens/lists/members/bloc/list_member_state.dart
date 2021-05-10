part of 'list_member_bloc.dart';

abstract class ListMemberState extends Equatable {
  const ListMemberState();
}

extension ListMemberStateExtension on ListMemberState {
  bool get isLoading => this is ListMemberInitialLoading;

  bool get hasResult => this is ListMembersResult || this is MembersLoadingMore;

  bool get hasMoreData => membersCursor != null && membersCursor != '0';

  bool get loadingMore => this is MembersLoadingMore;

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

class ListMemberInitialLoading extends ListMemberState {
  const ListMemberInitialLoading();

  @override
  List<Object> get props => <Object>[];
}

class ListMembersResult extends ListMemberState {
  const ListMembersResult({
    required this.members,
    required this.membersCursor,
  });

  final List<UserData> members;

  final String membersCursor;

  @override
  List<Object?> get props => <Object>[
        members,
        membersCursor,
      ];
}

class NoListMembersResult extends ListMemberState {
  const NoListMembersResult();

  @override
  List<Object?> get props => <Object>[];
}

class ListMemberFailure extends ListMemberState {
  const ListMemberFailure();

  @override
  List<Object?> get props => <Object>[];
}

class MembersLoadingMore extends ListMemberState {
  const MembersLoadingMore({
    required this.members,
    required this.membersCursor,
  });

  final List<UserData> members;

  final String? membersCursor;

  @override
  List<Object?> get props => <Object>[];
}
