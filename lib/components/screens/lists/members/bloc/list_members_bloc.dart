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
    required this.listId,
  }) : super(const ListMembersInitialLoading()) {
    on<ListMembersEvent>((event, emit) => event.handle(this, emit));
    add(const ShowListMembers());
  }

  final String listId;

  final ListsService listsService = app<TwitterApi>().listsService;

  Completer<void> requestMoreCompleter = Completer<void>();
}
