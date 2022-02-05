import 'package:freezed_annotation/freezed_annotation.dart';

part 'paginated_state.freezed.dart';

@freezed
class PaginatedState<T> with _$PaginatedState<T> {
  const factory PaginatedState.initial() = PaginatedStateInitial;
  const factory PaginatedState.loading() = PaginatedStateLoading;

  const factory PaginatedState.data({
    required T data,
    int? cursor,
  }) = PaginatedStateData;

  const factory PaginatedState.noData() = PaginatedStateNoData;

  const factory PaginatedState.loadingMore({
    required T data,
  }) = PaginatedStateLoadingMore;

  const factory PaginatedState.error() = PaginatedStateError;
}

extension PaginatedStateExtension<T> on PaginatedState<T> {
  T? get data => mapOrNull(
        data: (value) => value.data,
        loadingMore: (value) => value.data,
      );

  bool get canLoadMore => maybeMap(
        data: (value) => value.cursor != null && value.cursor != 0,
        orElse: () => false,
      );
}
