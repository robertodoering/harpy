part of 'lists_bloc.dart';

abstract class ListsState extends Equatable {
  const ListsState();
}

extension ListsStateExtension on ListsState {
  bool get isLoading => this is ListsInitialLoading;

  bool get hasFailed => this is ListsFailure;

  bool get hasResult => this is ListsResult;

  List<TwitterList> get lists {
    if (this is ListsResult) {
      return (this as ListsResult).lists;
    } else {
      return <TwitterList>[];
    }
  }
}

class ListsInitial extends ListsState {
  const ListsInitial();

  @override
  List<Object> get props => <Object>[];
}

/// The state when the lists are loaded initially.
class ListsInitialLoading extends ListsState {
  const ListsInitialLoading();

  @override
  List<Object> get props => <Object>[];
}

/// The state when the lists have successfully been requested.
class ListsResult extends ListsState {
  const ListsResult({
    @required this.lists,
  });

  final List<TwitterList> lists;

  @override
  List<Object> get props => <Object>[
        lists,
      ];
}

/// The state when the request was successful but no lists exist for the
/// searched user.
class ListsNoResult extends ListsState {
  const ListsNoResult();

  @override
  List<Object> get props => <Object>[];
}

/// The state when requesting the lists failed.
class ListsFailure extends ListsState {
  const ListsFailure();

  @override
  List<Object> get props => <Object>[];
}
