// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'paginated_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$PaginatedStateTearOff {
  const _$PaginatedStateTearOff();

  PaginatedStateData<T> data<T>({required T data, int? cursor}) {
    return PaginatedStateData<T>(
      data: data,
      cursor: cursor,
    );
  }

  PaginatedStateLoadingMore<T> loadingMore<T>({required T data}) {
    return PaginatedStateLoadingMore<T>(
      data: data,
    );
  }

  PaginatedStateInitial<T> initial<T>() {
    return PaginatedStateInitial<T>();
  }

  PaginatedStateLoading<T> loading<T>() {
    return PaginatedStateLoading<T>();
  }

  PaginatedStateError<T> error<T>() {
    return PaginatedStateError<T>();
  }

  PaginatedStateNoData<T> noData<T>() {
    return PaginatedStateNoData<T>();
  }
}

/// @nodoc
const $PaginatedState = _$PaginatedStateTearOff();

/// @nodoc
mixin _$PaginatedState<T> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T data, int? cursor) data,
    required TResult Function(T data) loadingMore,
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() error,
    required TResult Function() noData,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(T data, int? cursor)? data,
    TResult Function(T data)? loadingMore,
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? error,
    TResult Function()? noData,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T data, int? cursor)? data,
    TResult Function(T data)? loadingMore,
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? error,
    TResult Function()? noData,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PaginatedStateData<T> value) data,
    required TResult Function(PaginatedStateLoadingMore<T> value) loadingMore,
    required TResult Function(PaginatedStateInitial<T> value) initial,
    required TResult Function(PaginatedStateLoading<T> value) loading,
    required TResult Function(PaginatedStateError<T> value) error,
    required TResult Function(PaginatedStateNoData<T> value) noData,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(PaginatedStateData<T> value)? data,
    TResult Function(PaginatedStateLoadingMore<T> value)? loadingMore,
    TResult Function(PaginatedStateInitial<T> value)? initial,
    TResult Function(PaginatedStateLoading<T> value)? loading,
    TResult Function(PaginatedStateError<T> value)? error,
    TResult Function(PaginatedStateNoData<T> value)? noData,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PaginatedStateData<T> value)? data,
    TResult Function(PaginatedStateLoadingMore<T> value)? loadingMore,
    TResult Function(PaginatedStateInitial<T> value)? initial,
    TResult Function(PaginatedStateLoading<T> value)? loading,
    TResult Function(PaginatedStateError<T> value)? error,
    TResult Function(PaginatedStateNoData<T> value)? noData,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginatedStateCopyWith<T, $Res> {
  factory $PaginatedStateCopyWith(
          PaginatedState<T> value, $Res Function(PaginatedState<T>) then) =
      _$PaginatedStateCopyWithImpl<T, $Res>;
}

/// @nodoc
class _$PaginatedStateCopyWithImpl<T, $Res>
    implements $PaginatedStateCopyWith<T, $Res> {
  _$PaginatedStateCopyWithImpl(this._value, this._then);

  final PaginatedState<T> _value;
  // ignore: unused_field
  final $Res Function(PaginatedState<T>) _then;
}

/// @nodoc
abstract class $PaginatedStateDataCopyWith<T, $Res> {
  factory $PaginatedStateDataCopyWith(PaginatedStateData<T> value,
          $Res Function(PaginatedStateData<T>) then) =
      _$PaginatedStateDataCopyWithImpl<T, $Res>;
  $Res call({T data, int? cursor});
}

/// @nodoc
class _$PaginatedStateDataCopyWithImpl<T, $Res>
    extends _$PaginatedStateCopyWithImpl<T, $Res>
    implements $PaginatedStateDataCopyWith<T, $Res> {
  _$PaginatedStateDataCopyWithImpl(
      PaginatedStateData<T> _value, $Res Function(PaginatedStateData<T>) _then)
      : super(_value, (v) => _then(v as PaginatedStateData<T>));

  @override
  PaginatedStateData<T> get _value => super._value as PaginatedStateData<T>;

  @override
  $Res call({
    Object? data = freezed,
    Object? cursor = freezed,
  }) {
    return _then(PaginatedStateData<T>(
      data: data == freezed
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as T,
      cursor: cursor == freezed
          ? _value.cursor
          : cursor // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$PaginatedStateData<T> implements PaginatedStateData<T> {
  const _$PaginatedStateData({required this.data, this.cursor});

  @override
  final T data;
  @override
  final int? cursor;

  @override
  String toString() {
    return 'PaginatedState<$T>.data(data: $data, cursor: $cursor)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PaginatedStateData<T> &&
            const DeepCollectionEquality().equals(other.data, data) &&
            (identical(other.cursor, cursor) || other.cursor == cursor));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(data), cursor);

  @JsonKey(ignore: true)
  @override
  $PaginatedStateDataCopyWith<T, PaginatedStateData<T>> get copyWith =>
      _$PaginatedStateDataCopyWithImpl<T, PaginatedStateData<T>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T data, int? cursor) data,
    required TResult Function(T data) loadingMore,
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() error,
    required TResult Function() noData,
  }) {
    return data(this.data, cursor);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(T data, int? cursor)? data,
    TResult Function(T data)? loadingMore,
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? error,
    TResult Function()? noData,
  }) {
    return data?.call(this.data, cursor);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T data, int? cursor)? data,
    TResult Function(T data)? loadingMore,
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? error,
    TResult Function()? noData,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(this.data, cursor);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PaginatedStateData<T> value) data,
    required TResult Function(PaginatedStateLoadingMore<T> value) loadingMore,
    required TResult Function(PaginatedStateInitial<T> value) initial,
    required TResult Function(PaginatedStateLoading<T> value) loading,
    required TResult Function(PaginatedStateError<T> value) error,
    required TResult Function(PaginatedStateNoData<T> value) noData,
  }) {
    return data(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(PaginatedStateData<T> value)? data,
    TResult Function(PaginatedStateLoadingMore<T> value)? loadingMore,
    TResult Function(PaginatedStateInitial<T> value)? initial,
    TResult Function(PaginatedStateLoading<T> value)? loading,
    TResult Function(PaginatedStateError<T> value)? error,
    TResult Function(PaginatedStateNoData<T> value)? noData,
  }) {
    return data?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PaginatedStateData<T> value)? data,
    TResult Function(PaginatedStateLoadingMore<T> value)? loadingMore,
    TResult Function(PaginatedStateInitial<T> value)? initial,
    TResult Function(PaginatedStateLoading<T> value)? loading,
    TResult Function(PaginatedStateError<T> value)? error,
    TResult Function(PaginatedStateNoData<T> value)? noData,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(this);
    }
    return orElse();
  }
}

abstract class PaginatedStateData<T> implements PaginatedState<T> {
  const factory PaginatedStateData({required T data, int? cursor}) =
      _$PaginatedStateData<T>;

  T get data;
  int? get cursor;
  @JsonKey(ignore: true)
  $PaginatedStateDataCopyWith<T, PaginatedStateData<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginatedStateLoadingMoreCopyWith<T, $Res> {
  factory $PaginatedStateLoadingMoreCopyWith(PaginatedStateLoadingMore<T> value,
          $Res Function(PaginatedStateLoadingMore<T>) then) =
      _$PaginatedStateLoadingMoreCopyWithImpl<T, $Res>;
  $Res call({T data});
}

/// @nodoc
class _$PaginatedStateLoadingMoreCopyWithImpl<T, $Res>
    extends _$PaginatedStateCopyWithImpl<T, $Res>
    implements $PaginatedStateLoadingMoreCopyWith<T, $Res> {
  _$PaginatedStateLoadingMoreCopyWithImpl(PaginatedStateLoadingMore<T> _value,
      $Res Function(PaginatedStateLoadingMore<T>) _then)
      : super(_value, (v) => _then(v as PaginatedStateLoadingMore<T>));

  @override
  PaginatedStateLoadingMore<T> get _value =>
      super._value as PaginatedStateLoadingMore<T>;

  @override
  $Res call({
    Object? data = freezed,
  }) {
    return _then(PaginatedStateLoadingMore<T>(
      data: data == freezed
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as T,
    ));
  }
}

/// @nodoc

class _$PaginatedStateLoadingMore<T> implements PaginatedStateLoadingMore<T> {
  const _$PaginatedStateLoadingMore({required this.data});

  @override
  final T data;

  @override
  String toString() {
    return 'PaginatedState<$T>.loadingMore(data: $data)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PaginatedStateLoadingMore<T> &&
            const DeepCollectionEquality().equals(other.data, data));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(data));

  @JsonKey(ignore: true)
  @override
  $PaginatedStateLoadingMoreCopyWith<T, PaginatedStateLoadingMore<T>>
      get copyWith => _$PaginatedStateLoadingMoreCopyWithImpl<T,
          PaginatedStateLoadingMore<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T data, int? cursor) data,
    required TResult Function(T data) loadingMore,
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() error,
    required TResult Function() noData,
  }) {
    return loadingMore(this.data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(T data, int? cursor)? data,
    TResult Function(T data)? loadingMore,
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? error,
    TResult Function()? noData,
  }) {
    return loadingMore?.call(this.data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T data, int? cursor)? data,
    TResult Function(T data)? loadingMore,
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? error,
    TResult Function()? noData,
    required TResult orElse(),
  }) {
    if (loadingMore != null) {
      return loadingMore(this.data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PaginatedStateData<T> value) data,
    required TResult Function(PaginatedStateLoadingMore<T> value) loadingMore,
    required TResult Function(PaginatedStateInitial<T> value) initial,
    required TResult Function(PaginatedStateLoading<T> value) loading,
    required TResult Function(PaginatedStateError<T> value) error,
    required TResult Function(PaginatedStateNoData<T> value) noData,
  }) {
    return loadingMore(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(PaginatedStateData<T> value)? data,
    TResult Function(PaginatedStateLoadingMore<T> value)? loadingMore,
    TResult Function(PaginatedStateInitial<T> value)? initial,
    TResult Function(PaginatedStateLoading<T> value)? loading,
    TResult Function(PaginatedStateError<T> value)? error,
    TResult Function(PaginatedStateNoData<T> value)? noData,
  }) {
    return loadingMore?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PaginatedStateData<T> value)? data,
    TResult Function(PaginatedStateLoadingMore<T> value)? loadingMore,
    TResult Function(PaginatedStateInitial<T> value)? initial,
    TResult Function(PaginatedStateLoading<T> value)? loading,
    TResult Function(PaginatedStateError<T> value)? error,
    TResult Function(PaginatedStateNoData<T> value)? noData,
    required TResult orElse(),
  }) {
    if (loadingMore != null) {
      return loadingMore(this);
    }
    return orElse();
  }
}

abstract class PaginatedStateLoadingMore<T> implements PaginatedState<T> {
  const factory PaginatedStateLoadingMore({required T data}) =
      _$PaginatedStateLoadingMore<T>;

  T get data;
  @JsonKey(ignore: true)
  $PaginatedStateLoadingMoreCopyWith<T, PaginatedStateLoadingMore<T>>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginatedStateInitialCopyWith<T, $Res> {
  factory $PaginatedStateInitialCopyWith(PaginatedStateInitial<T> value,
          $Res Function(PaginatedStateInitial<T>) then) =
      _$PaginatedStateInitialCopyWithImpl<T, $Res>;
}

/// @nodoc
class _$PaginatedStateInitialCopyWithImpl<T, $Res>
    extends _$PaginatedStateCopyWithImpl<T, $Res>
    implements $PaginatedStateInitialCopyWith<T, $Res> {
  _$PaginatedStateInitialCopyWithImpl(PaginatedStateInitial<T> _value,
      $Res Function(PaginatedStateInitial<T>) _then)
      : super(_value, (v) => _then(v as PaginatedStateInitial<T>));

  @override
  PaginatedStateInitial<T> get _value =>
      super._value as PaginatedStateInitial<T>;
}

/// @nodoc

class _$PaginatedStateInitial<T> implements PaginatedStateInitial<T> {
  const _$PaginatedStateInitial();

  @override
  String toString() {
    return 'PaginatedState<$T>.initial()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is PaginatedStateInitial<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T data, int? cursor) data,
    required TResult Function(T data) loadingMore,
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() error,
    required TResult Function() noData,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(T data, int? cursor)? data,
    TResult Function(T data)? loadingMore,
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? error,
    TResult Function()? noData,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T data, int? cursor)? data,
    TResult Function(T data)? loadingMore,
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? error,
    TResult Function()? noData,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PaginatedStateData<T> value) data,
    required TResult Function(PaginatedStateLoadingMore<T> value) loadingMore,
    required TResult Function(PaginatedStateInitial<T> value) initial,
    required TResult Function(PaginatedStateLoading<T> value) loading,
    required TResult Function(PaginatedStateError<T> value) error,
    required TResult Function(PaginatedStateNoData<T> value) noData,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(PaginatedStateData<T> value)? data,
    TResult Function(PaginatedStateLoadingMore<T> value)? loadingMore,
    TResult Function(PaginatedStateInitial<T> value)? initial,
    TResult Function(PaginatedStateLoading<T> value)? loading,
    TResult Function(PaginatedStateError<T> value)? error,
    TResult Function(PaginatedStateNoData<T> value)? noData,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PaginatedStateData<T> value)? data,
    TResult Function(PaginatedStateLoadingMore<T> value)? loadingMore,
    TResult Function(PaginatedStateInitial<T> value)? initial,
    TResult Function(PaginatedStateLoading<T> value)? loading,
    TResult Function(PaginatedStateError<T> value)? error,
    TResult Function(PaginatedStateNoData<T> value)? noData,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class PaginatedStateInitial<T> implements PaginatedState<T> {
  const factory PaginatedStateInitial() = _$PaginatedStateInitial<T>;
}

/// @nodoc
abstract class $PaginatedStateLoadingCopyWith<T, $Res> {
  factory $PaginatedStateLoadingCopyWith(PaginatedStateLoading<T> value,
          $Res Function(PaginatedStateLoading<T>) then) =
      _$PaginatedStateLoadingCopyWithImpl<T, $Res>;
}

/// @nodoc
class _$PaginatedStateLoadingCopyWithImpl<T, $Res>
    extends _$PaginatedStateCopyWithImpl<T, $Res>
    implements $PaginatedStateLoadingCopyWith<T, $Res> {
  _$PaginatedStateLoadingCopyWithImpl(PaginatedStateLoading<T> _value,
      $Res Function(PaginatedStateLoading<T>) _then)
      : super(_value, (v) => _then(v as PaginatedStateLoading<T>));

  @override
  PaginatedStateLoading<T> get _value =>
      super._value as PaginatedStateLoading<T>;
}

/// @nodoc

class _$PaginatedStateLoading<T> implements PaginatedStateLoading<T> {
  const _$PaginatedStateLoading();

  @override
  String toString() {
    return 'PaginatedState<$T>.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is PaginatedStateLoading<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T data, int? cursor) data,
    required TResult Function(T data) loadingMore,
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() error,
    required TResult Function() noData,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(T data, int? cursor)? data,
    TResult Function(T data)? loadingMore,
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? error,
    TResult Function()? noData,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T data, int? cursor)? data,
    TResult Function(T data)? loadingMore,
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? error,
    TResult Function()? noData,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PaginatedStateData<T> value) data,
    required TResult Function(PaginatedStateLoadingMore<T> value) loadingMore,
    required TResult Function(PaginatedStateInitial<T> value) initial,
    required TResult Function(PaginatedStateLoading<T> value) loading,
    required TResult Function(PaginatedStateError<T> value) error,
    required TResult Function(PaginatedStateNoData<T> value) noData,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(PaginatedStateData<T> value)? data,
    TResult Function(PaginatedStateLoadingMore<T> value)? loadingMore,
    TResult Function(PaginatedStateInitial<T> value)? initial,
    TResult Function(PaginatedStateLoading<T> value)? loading,
    TResult Function(PaginatedStateError<T> value)? error,
    TResult Function(PaginatedStateNoData<T> value)? noData,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PaginatedStateData<T> value)? data,
    TResult Function(PaginatedStateLoadingMore<T> value)? loadingMore,
    TResult Function(PaginatedStateInitial<T> value)? initial,
    TResult Function(PaginatedStateLoading<T> value)? loading,
    TResult Function(PaginatedStateError<T> value)? error,
    TResult Function(PaginatedStateNoData<T> value)? noData,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class PaginatedStateLoading<T> implements PaginatedState<T> {
  const factory PaginatedStateLoading() = _$PaginatedStateLoading<T>;
}

/// @nodoc
abstract class $PaginatedStateErrorCopyWith<T, $Res> {
  factory $PaginatedStateErrorCopyWith(PaginatedStateError<T> value,
          $Res Function(PaginatedStateError<T>) then) =
      _$PaginatedStateErrorCopyWithImpl<T, $Res>;
}

/// @nodoc
class _$PaginatedStateErrorCopyWithImpl<T, $Res>
    extends _$PaginatedStateCopyWithImpl<T, $Res>
    implements $PaginatedStateErrorCopyWith<T, $Res> {
  _$PaginatedStateErrorCopyWithImpl(PaginatedStateError<T> _value,
      $Res Function(PaginatedStateError<T>) _then)
      : super(_value, (v) => _then(v as PaginatedStateError<T>));

  @override
  PaginatedStateError<T> get _value => super._value as PaginatedStateError<T>;
}

/// @nodoc

class _$PaginatedStateError<T> implements PaginatedStateError<T> {
  const _$PaginatedStateError();

  @override
  String toString() {
    return 'PaginatedState<$T>.error()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is PaginatedStateError<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T data, int? cursor) data,
    required TResult Function(T data) loadingMore,
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() error,
    required TResult Function() noData,
  }) {
    return error();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(T data, int? cursor)? data,
    TResult Function(T data)? loadingMore,
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? error,
    TResult Function()? noData,
  }) {
    return error?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T data, int? cursor)? data,
    TResult Function(T data)? loadingMore,
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? error,
    TResult Function()? noData,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PaginatedStateData<T> value) data,
    required TResult Function(PaginatedStateLoadingMore<T> value) loadingMore,
    required TResult Function(PaginatedStateInitial<T> value) initial,
    required TResult Function(PaginatedStateLoading<T> value) loading,
    required TResult Function(PaginatedStateError<T> value) error,
    required TResult Function(PaginatedStateNoData<T> value) noData,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(PaginatedStateData<T> value)? data,
    TResult Function(PaginatedStateLoadingMore<T> value)? loadingMore,
    TResult Function(PaginatedStateInitial<T> value)? initial,
    TResult Function(PaginatedStateLoading<T> value)? loading,
    TResult Function(PaginatedStateError<T> value)? error,
    TResult Function(PaginatedStateNoData<T> value)? noData,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PaginatedStateData<T> value)? data,
    TResult Function(PaginatedStateLoadingMore<T> value)? loadingMore,
    TResult Function(PaginatedStateInitial<T> value)? initial,
    TResult Function(PaginatedStateLoading<T> value)? loading,
    TResult Function(PaginatedStateError<T> value)? error,
    TResult Function(PaginatedStateNoData<T> value)? noData,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class PaginatedStateError<T> implements PaginatedState<T> {
  const factory PaginatedStateError() = _$PaginatedStateError<T>;
}

/// @nodoc
abstract class $PaginatedStateNoDataCopyWith<T, $Res> {
  factory $PaginatedStateNoDataCopyWith(PaginatedStateNoData<T> value,
          $Res Function(PaginatedStateNoData<T>) then) =
      _$PaginatedStateNoDataCopyWithImpl<T, $Res>;
}

/// @nodoc
class _$PaginatedStateNoDataCopyWithImpl<T, $Res>
    extends _$PaginatedStateCopyWithImpl<T, $Res>
    implements $PaginatedStateNoDataCopyWith<T, $Res> {
  _$PaginatedStateNoDataCopyWithImpl(PaginatedStateNoData<T> _value,
      $Res Function(PaginatedStateNoData<T>) _then)
      : super(_value, (v) => _then(v as PaginatedStateNoData<T>));

  @override
  PaginatedStateNoData<T> get _value => super._value as PaginatedStateNoData<T>;
}

/// @nodoc

class _$PaginatedStateNoData<T> implements PaginatedStateNoData<T> {
  const _$PaginatedStateNoData();

  @override
  String toString() {
    return 'PaginatedState<$T>.noData()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is PaginatedStateNoData<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T data, int? cursor) data,
    required TResult Function(T data) loadingMore,
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() error,
    required TResult Function() noData,
  }) {
    return noData();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(T data, int? cursor)? data,
    TResult Function(T data)? loadingMore,
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? error,
    TResult Function()? noData,
  }) {
    return noData?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T data, int? cursor)? data,
    TResult Function(T data)? loadingMore,
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? error,
    TResult Function()? noData,
    required TResult orElse(),
  }) {
    if (noData != null) {
      return noData();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PaginatedStateData<T> value) data,
    required TResult Function(PaginatedStateLoadingMore<T> value) loadingMore,
    required TResult Function(PaginatedStateInitial<T> value) initial,
    required TResult Function(PaginatedStateLoading<T> value) loading,
    required TResult Function(PaginatedStateError<T> value) error,
    required TResult Function(PaginatedStateNoData<T> value) noData,
  }) {
    return noData(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(PaginatedStateData<T> value)? data,
    TResult Function(PaginatedStateLoadingMore<T> value)? loadingMore,
    TResult Function(PaginatedStateInitial<T> value)? initial,
    TResult Function(PaginatedStateLoading<T> value)? loading,
    TResult Function(PaginatedStateError<T> value)? error,
    TResult Function(PaginatedStateNoData<T> value)? noData,
  }) {
    return noData?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PaginatedStateData<T> value)? data,
    TResult Function(PaginatedStateLoadingMore<T> value)? loadingMore,
    TResult Function(PaginatedStateInitial<T> value)? initial,
    TResult Function(PaginatedStateLoading<T> value)? loading,
    TResult Function(PaginatedStateError<T> value)? error,
    TResult Function(PaginatedStateNoData<T> value)? noData,
    required TResult orElse(),
  }) {
    if (noData != null) {
      return noData(this);
    }
    return orElse();
  }
}

abstract class PaginatedStateNoData<T> implements PaginatedState<T> {
  const factory PaginatedStateNoData() = _$PaginatedStateNoData<T>;
}
