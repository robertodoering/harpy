import 'package:freezed_annotation/freezed_annotation.dart';

part 'paginated_state.freezed.dart';

@freezed
class PaginatedState<T> with _$PaginatedState<T> {
  const factory PaginatedState.data({
    required T data,
    int? cursor,
  }) = PaginatedStateData;

  const factory PaginatedState.loadingMore({
    required T data,
  }) = PaginatedStateLoadingMore;

  const factory PaginatedState.initial() = PaginatedStateInitial;
  const factory PaginatedState.loading() = PaginatedStateLoading;
  const factory PaginatedState.error() = PaginatedStateError;
  const factory PaginatedState.noData() = PaginatedStateNoData;
}

extension PaginatedStateExtension<T> on PaginatedState<T> {
  T? get data => mapOrNull(
        data: (state) => state.data,
        loadingMore: (state) => state.data,
      );

  bool get canLoadMore => maybeMap(
        data: (data) => data.cursor != null && data.cursor != 0,
        orElse: () => false,
      );
}