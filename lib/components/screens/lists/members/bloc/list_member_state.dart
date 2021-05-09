part of 'list_member_bloc.dart';

abstract class ListMemberState extends Equatable {
  const ListMemberState();
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

  final List<User> members;

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
