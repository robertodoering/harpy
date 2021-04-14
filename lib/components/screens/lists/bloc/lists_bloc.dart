import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/core/core.dart';

part 'lists_event.dart';
part 'lists_state.dart';

class ListsBloc extends Bloc<ListsEvent, ListsState> {
  ListsBloc({
    @required this.userId,
  }) : super(const ListsInitial());

  final String userId;

  final ListsService listsService = app<TwitterApi>().listsService;

  @override
  Stream<ListsState> mapEventToState(
    ListsEvent event,
  ) async* {
    yield* event.applyAsync(currentState: state, bloc: this);
  }
}
