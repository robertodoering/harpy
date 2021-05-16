import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:equatable/equatable.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/core/core.dart';

part 'list_members_event.dart';
part 'list_members_state.dart';

class ListMembersBloc extends Bloc<ListMembersEvent, ListMembersState> {
  ListMembersBloc({
    required this.list,
  }) : super(const ListMembersInitialLoading()) {
    add(const ShowListMembers());
  }

  final TwitterListData list;

  final ListsService listsService = app<TwitterApi>().listsService;

  Completer<void> requestMoreCompleter = Completer<void>();

  @override
  Stream<ListMembersState> mapEventToState(
    ListMembersEvent event,
  ) async* {
    yield* event.applyAsync(currentState: state, bloc: this);
  }
}
