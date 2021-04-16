import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/core/core.dart';

part 'list_timeline_event.dart';
part 'list_timeline_state.dart';

class ListTimelineBloc extends Bloc<ListTimelineEvent, ListTimelineState> {
  ListTimelineBloc({
    @required this.listId,
  }) : super(const ListTimelineLoading()) {
    add(const RequestListTimeline());
  }

  final String listId;

  final ListsService listsService = app<TwitterApi>().listsService;

  @override
  Stream<ListTimelineState> mapEventToState(
    ListTimelineEvent event,
  ) async* {
    yield* event.applyAsync(currentState: state, bloc: this);
  }
}
