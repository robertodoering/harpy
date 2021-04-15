part of 'show_lists_bloc.dart';

abstract class ShowListsState extends Equatable {
  const ShowListsState();
}

extension ShowListsStateExtension on ShowListsState {
  bool get isLoading => this is ListsInitialLoading;

  bool get hasFailed => this is ListsFailure;

  bool get hasResult => this is ListsResult || this is ListsLoadingMore;

  bool get hasOwnerships => ownerships.isNotEmpty;

  bool get hasSubscriptions => subscriptions.isNotEmpty;

  bool get hasMoreOwnerships =>
      ownershipsCursor != null && ownershipsCursor != '0';

  bool get hasMoreSubscriptions =>
      subscriptionsCursor != null && subscriptionsCursor != '0';

  bool get loadingMoreOwnerships =>
      this is ListsLoadingMore && (this as ListsLoadingMore).loadingOwnerships;

  bool get loadingMoreSubscriptions =>
      this is ListsLoadingMore &&
      (this as ListsLoadingMore).loadingSubscriptions;

  List<TwitterListData> get ownerships {
    if (this is ListsResult) {
      return (this as ListsResult).ownerships;
    } else if (this is ListsLoadingMore) {
      return (this as ListsLoadingMore).ownerships;
    } else {
      return <TwitterListData>[];
    }
  }

  List<TwitterListData> get subscriptions {
    if (this is ListsResult) {
      return (this as ListsResult).subscriptions;
    } else if (this is ListsLoadingMore) {
      return (this as ListsLoadingMore).subscriptions;
    } else {
      return <TwitterListData>[];
    }
  }

  String get ownershipsCursor {
    if (this is ListsResult) {
      return (this as ListsResult).ownershipsCursor;
    } else {
      return null;
    }
  }

  String get subscriptionsCursor {
    if (this is ListsResult) {
      return (this as ListsResult).subscriptionsCursor;
    } else {
      return null;
    }
  }
}

/// The state when the lists are loaded initially.
class ListsInitialLoading extends ShowListsState {
  const ListsInitialLoading();

  @override
  List<Object> get props => <Object>[];
}

/// The state when the lists have successfully been requested.
class ListsResult extends ShowListsState {
  const ListsResult({
    @required this.ownerships,
    @required this.subscriptions,
    @required this.ownershipsCursor,
    @required this.subscriptionsCursor,
  });

  final List<TwitterListData> ownerships;
  final List<TwitterListData> subscriptions;

  final String ownershipsCursor;
  final String subscriptionsCursor;

  @override
  List<Object> get props => <Object>[
        ownerships,
        subscriptions,
        ownershipsCursor,
        subscriptionsCursor,
      ];
}

/// The state when loading more ownerships or more subscriptions.
class ListsLoadingMore extends ShowListsState {
  const ListsLoadingMore.loadingOwnerships({
    @required this.ownerships,
    @required this.subscriptions,
    @required this.ownershipsCursor,
    @required this.subscriptionsCursor,
  })  : loadingOwnerships = true,
        loadingSubscriptions = false;

  const ListsLoadingMore.loadingSubscriptions({
    @required this.ownerships,
    @required this.subscriptions,
    @required this.ownershipsCursor,
    @required this.subscriptionsCursor,
  })  : loadingOwnerships = false,
        loadingSubscriptions = true;

  final bool loadingOwnerships;
  final bool loadingSubscriptions;

  final List<TwitterListData> ownerships;
  final List<TwitterListData> subscriptions;

  final String ownershipsCursor;
  final String subscriptionsCursor;

  @override
  List<Object> get props => <Object>[
        loadingOwnerships,
        loadingSubscriptions,
      ];
}

/// The state when the request was successful but no lists exist for the
/// searched user.
class ListsNoResult extends ShowListsState {
  const ListsNoResult();

  @override
  List<Object> get props => <Object>[];
}

/// The state when requesting the lists failed.
class ListsFailure extends ShowListsState {
  const ListsFailure();

  @override
  List<Object> get props => <Object>[];
}
