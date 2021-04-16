import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/core/core.dart';

part 'list_timeline_event.dart';
part 'list_timeline_state.dart';

/// Handles requesting the tweets for the twitter list specified with [listId].
class ListTimelineBloc extends Bloc<ListTimelineEvent, ListTimelineState>
    with RequestLock {
  ListTimelineBloc({
    @required this.listId,
  }) : super(const ListTimelineLoading()) {
    add(const RequestListTimeline());
  }

  final String listId;

  final ListsService listsService = app<TwitterApi>().listsService;

  /// Completes when older tweets for the timeline have been requested using
  /// [RequestOlderListTimeline].
  Completer<void> requestOlderCompleter = Completer<void>();

  @override
  Stream<ListTimelineState> mapEventToState(
    ListTimelineEvent event,
  ) async* {
    yield* event.applyAsync(currentState: state, bloc: this);
  }
}
