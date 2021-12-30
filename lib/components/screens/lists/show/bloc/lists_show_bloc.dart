import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:built_collection/built_collection.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/core/core.dart';

part 'lists_show_bloc.freezed.dart';
part 'lists_show_event.dart';

class ListsShowBloc extends Bloc<ListsShowEvent, ListsShowState> {
  ListsShowBloc({
    required this.userId,
  }) : super(const ListsShowState.loading()) {
    on<ListsShowEvent>((event, emit) => event.handle(this, emit));
    add(const ListsShowEvent.show());
  }

  /// The id of the user for whom to show the list.
  ///
  /// When `null`, the authenticated user's lists will be returned.
  final String? userId;
}

@freezed
class ListsShowState with _$ListsShowState {
  const factory ListsShowState.loading() = _Loading;

  const factory ListsShowState.data({
    required BuiltList<TwitterListData> ownerships,
    required BuiltList<TwitterListData> subscriptions,
    required String? ownershipsCursor,
    required String? subscriptionsCursor,
  }) = _Data;

  const factory ListsShowState.noData() = _NoData;

  const factory ListsShowState.loadingMoreOwnerships({
    required BuiltList<TwitterListData> ownerships,
    required BuiltList<TwitterListData> subscriptions,
  }) = _LoadingMoreOwnerships;

  const factory ListsShowState.loadingMoreSubscriptions({
    required BuiltList<TwitterListData> ownerships,
    required BuiltList<TwitterListData> subscriptions,
  }) = _LoadingMoreSubscriptions;

  const factory ListsShowState.error() = _Error;
}

extension ListsShowStateExtension on ListsShowState {
  bool get loadingMoreOwnerships => this is _LoadingMoreOwnerships;
  bool get loadingMoreSubscriptions => this is _LoadingMoreSubscriptions;

  BuiltList<TwitterListData> get ownerships => maybeMap(
        data: (value) => value.ownerships,
        loadingMoreOwnerships: (value) => value.ownerships,
        loadingMoreSubscriptions: (value) => value.ownerships,
        orElse: BuiltList.new,
      );

  BuiltList<TwitterListData> get subscriptions => maybeMap(
        data: (value) => value.subscriptions,
        loadingMoreOwnerships: (value) => value.subscriptions,
        loadingMoreSubscriptions: (value) => value.subscriptions,
        orElse: BuiltList.new,
      );

  bool get hasMoreOwnerships => maybeMap(
        data: (value) => value.ownershipsCursor != '0',
        orElse: () => false,
      );

  bool get hasMoreSubscriptions => maybeMap(
        data: (value) => value.subscriptionsCursor != '0',
        orElse: () => false,
      );
}
