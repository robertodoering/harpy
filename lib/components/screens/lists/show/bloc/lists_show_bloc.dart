import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:equatable/equatable.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/api/twitter/data/twitter_list_data.dart';
import 'package:harpy/core/core.dart';

part 'lists_show_event.dart';
part 'lists_show_state.dart';

class ListsShowBloc extends Bloc<ListsShowEvent, ListsShowState> {
  ListsShowBloc({
    required this.userId,
  }) : super(const ListsInitialLoading()) {
    add(const ShowLists());
  }

  /// The id of the user whose list to show.
  ///
  /// When `null`, the authenticated user's lists will be returned.
  final String? userId;

  @override
  Stream<ListsShowState> mapEventToState(
    ListsShowEvent event,
  ) async* {
    yield* event.applyAsync(currentState: state, bloc: this);
  }
}
