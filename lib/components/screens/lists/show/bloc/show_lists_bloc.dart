import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/api/twitter/data/twitter_list_data.dart';
import 'package:harpy/core/core.dart';

part 'show_lists_event.dart';
part 'show_lists_state.dart';

class ShowListsBloc extends Bloc<ShowListsEvent, ShowListsState> {
  ShowListsBloc({
    @required this.userId,
  }) : super(const ListsInitialLoading()) {
    add(const ShowLists());
  }

  /// The id of the user whose list to show.
  ///
  /// When `null`, the authenticated user's lists will be returned.
  final String userId;

  final ListsService listsService = app<TwitterApi>().listsService;

  @override
  Stream<ShowListsState> mapEventToState(
    ShowListsEvent event,
  ) async* {
    yield* event.applyAsync(currentState: state, bloc: this);
  }
}
