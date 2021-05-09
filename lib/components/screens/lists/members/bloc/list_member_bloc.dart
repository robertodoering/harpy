import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:equatable/equatable.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/core/core.dart';

part 'list_member_event.dart';
part 'list_member_state.dart';

class ListMemberBloc extends Bloc<ListMemberEvent, ListMemberState> {
  ListMemberBloc({
    required this.list,
  }) : super(const ListMemberInitialLoading()) {
    add(const ShowListMembers());
  }

  final TwitterListData list;

  final ListsService listsService = app<TwitterApi>().listsService;

  @override
  Stream<ListMemberState> mapEventToState(
    ListMemberEvent event,
  ) async* {
    yield* event.applyAsync(currentState: state, bloc: this);
  }
}
