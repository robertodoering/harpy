// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'tweet_search_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$NewTweetSearchStateTearOff {
  const _$NewTweetSearchStateTearOff();

  _Initial initial() {
    return const _Initial();
  }

  _Data data(
      {required BuiltList<TweetData> tweets,
      required String query,
      TweetSearchFilter? filter}) {
    return _Data(
      tweets: tweets,
      query: query,
      filter: filter,
    );
  }

  _NoData noData({required String query, TweetSearchFilter? filter}) {
    return _NoData(
      query: query,
      filter: filter,
    );
  }

  _Loading loading({required String query}) {
    return _Loading(
      query: query,
    );
  }

  _Error error({required String query, TweetSearchFilter? filter}) {
    return _Error(
      query: query,
      filter: filter,
    );
  }
}

/// @nodoc
const $NewTweetSearchState = _$NewTweetSearchStateTearOff();

/// @nodoc
mixin _$NewTweetSearchState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(BuiltList<TweetData> tweets, String query,
            TweetSearchFilter? filter)
        data,
    required TResult Function(String query, TweetSearchFilter? filter) noData,
    required TResult Function(String query) loading,
    required TResult Function(String query, TweetSearchFilter? filter) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(BuiltList<TweetData> tweets, String query,
            TweetSearchFilter? filter)?
        data,
    TResult Function(String query, TweetSearchFilter? filter)? noData,
    TResult Function(String query)? loading,
    TResult Function(String query, TweetSearchFilter? filter)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(BuiltList<TweetData> tweets, String query,
            TweetSearchFilter? filter)?
        data,
    TResult Function(String query, TweetSearchFilter? filter)? noData,
    TResult Function(String query)? loading,
    TResult Function(String query, TweetSearchFilter? filter)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Data value) data,
    required TResult Function(_NoData value) noData,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Error value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Data value)? data,
    TResult Function(_NoData value)? noData,
    TResult Function(_Loading value)? loading,
    TResult Function(_Error value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Data value)? data,
    TResult Function(_NoData value)? noData,
    TResult Function(_Loading value)? loading,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NewTweetSearchStateCopyWith<$Res> {
  factory $NewTweetSearchStateCopyWith(
          NewTweetSearchState value, $Res Function(NewTweetSearchState) then) =
      _$NewTweetSearchStateCopyWithImpl<$Res>;
}

/// @nodoc
class _$NewTweetSearchStateCopyWithImpl<$Res>
    implements $NewTweetSearchStateCopyWith<$Res> {
  _$NewTweetSearchStateCopyWithImpl(this._value, this._then);

  final NewTweetSearchState _value;
  // ignore: unused_field
  final $Res Function(NewTweetSearchState) _then;
}

/// @nodoc
abstract class _$InitialCopyWith<$Res> {
  factory _$InitialCopyWith(_Initial value, $Res Function(_Initial) then) =
      __$InitialCopyWithImpl<$Res>;
}

/// @nodoc
class __$InitialCopyWithImpl<$Res>
    extends _$NewTweetSearchStateCopyWithImpl<$Res>
    implements _$InitialCopyWith<$Res> {
  __$InitialCopyWithImpl(_Initial _value, $Res Function(_Initial) _then)
      : super(_value, (v) => _then(v as _Initial));

  @override
  _Initial get _value => super._value as _Initial;
}

/// @nodoc

class _$_Initial implements _Initial {
  const _$_Initial();

  @override
  String toString() {
    return 'NewTweetSearchState.initial()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _Initial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(BuiltList<TweetData> tweets, String query,
            TweetSearchFilter? filter)
        data,
    required TResult Function(String query, TweetSearchFilter? filter) noData,
    required TResult Function(String query) loading,
    required TResult Function(String query, TweetSearchFilter? filter) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(BuiltList<TweetData> tweets, String query,
            TweetSearchFilter? filter)?
        data,
    TResult Function(String query, TweetSearchFilter? filter)? noData,
    TResult Function(String query)? loading,
    TResult Function(String query, TweetSearchFilter? filter)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(BuiltList<TweetData> tweets, String query,
            TweetSearchFilter? filter)?
        data,
    TResult Function(String query, TweetSearchFilter? filter)? noData,
    TResult Function(String query)? loading,
    TResult Function(String query, TweetSearchFilter? filter)? error,
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
    required TResult Function(_Initial value) initial,
    required TResult Function(_Data value) data,
    required TResult Function(_NoData value) noData,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Error value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Data value)? data,
    TResult Function(_NoData value)? noData,
    TResult Function(_Loading value)? loading,
    TResult Function(_Error value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Data value)? data,
    TResult Function(_NoData value)? noData,
    TResult Function(_Loading value)? loading,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements NewTweetSearchState {
  const factory _Initial() = _$_Initial;
}

/// @nodoc
abstract class _$DataCopyWith<$Res> {
  factory _$DataCopyWith(_Data value, $Res Function(_Data) then) =
      __$DataCopyWithImpl<$Res>;
  $Res call(
      {BuiltList<TweetData> tweets, String query, TweetSearchFilter? filter});
}

/// @nodoc
class __$DataCopyWithImpl<$Res> extends _$NewTweetSearchStateCopyWithImpl<$Res>
    implements _$DataCopyWith<$Res> {
  __$DataCopyWithImpl(_Data _value, $Res Function(_Data) _then)
      : super(_value, (v) => _then(v as _Data));

  @override
  _Data get _value => super._value as _Data;

  @override
  $Res call({
    Object? tweets = freezed,
    Object? query = freezed,
    Object? filter = freezed,
  }) {
    return _then(_Data(
      tweets: tweets == freezed
          ? _value.tweets
          : tweets // ignore: cast_nullable_to_non_nullable
              as BuiltList<TweetData>,
      query: query == freezed
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
      filter: filter == freezed
          ? _value.filter
          : filter // ignore: cast_nullable_to_non_nullable
              as TweetSearchFilter?,
    ));
  }
}

/// @nodoc

class _$_Data implements _Data {
  const _$_Data({required this.tweets, required this.query, this.filter});

  @override
  final BuiltList<TweetData> tweets;
  @override

  /// The query that was used in the search request.
  ///
  /// Either built from the filter or manually entered by the user.
  final String query;
  @override

  /// The filter that built the query if a filter was used.
  ///
  /// `null` if the user entered the query manually.
  final TweetSearchFilter? filter;

  @override
  String toString() {
    return 'NewTweetSearchState.data(tweets: $tweets, query: $query, filter: $filter)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Data &&
            (identical(other.tweets, tweets) || other.tweets == tweets) &&
            (identical(other.query, query) || other.query == query) &&
            (identical(other.filter, filter) || other.filter == filter));
  }

  @override
  int get hashCode => Object.hash(runtimeType, tweets, query, filter);

  @JsonKey(ignore: true)
  @override
  _$DataCopyWith<_Data> get copyWith =>
      __$DataCopyWithImpl<_Data>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(BuiltList<TweetData> tweets, String query,
            TweetSearchFilter? filter)
        data,
    required TResult Function(String query, TweetSearchFilter? filter) noData,
    required TResult Function(String query) loading,
    required TResult Function(String query, TweetSearchFilter? filter) error,
  }) {
    return data(tweets, query, filter);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(BuiltList<TweetData> tweets, String query,
            TweetSearchFilter? filter)?
        data,
    TResult Function(String query, TweetSearchFilter? filter)? noData,
    TResult Function(String query)? loading,
    TResult Function(String query, TweetSearchFilter? filter)? error,
  }) {
    return data?.call(tweets, query, filter);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(BuiltList<TweetData> tweets, String query,
            TweetSearchFilter? filter)?
        data,
    TResult Function(String query, TweetSearchFilter? filter)? noData,
    TResult Function(String query)? loading,
    TResult Function(String query, TweetSearchFilter? filter)? error,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(tweets, query, filter);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Data value) data,
    required TResult Function(_NoData value) noData,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Error value) error,
  }) {
    return data(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Data value)? data,
    TResult Function(_NoData value)? noData,
    TResult Function(_Loading value)? loading,
    TResult Function(_Error value)? error,
  }) {
    return data?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Data value)? data,
    TResult Function(_NoData value)? noData,
    TResult Function(_Loading value)? loading,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(this);
    }
    return orElse();
  }
}

abstract class _Data implements NewTweetSearchState {
  const factory _Data(
      {required BuiltList<TweetData> tweets,
      required String query,
      TweetSearchFilter? filter}) = _$_Data;

  BuiltList<TweetData> get tweets;

  /// The query that was used in the search request.
  ///
  /// Either built from the filter or manually entered by the user.
  String get query;

  /// The filter that built the query if a filter was used.
  ///
  /// `null` if the user entered the query manually.
  TweetSearchFilter? get filter;
  @JsonKey(ignore: true)
  _$DataCopyWith<_Data> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$NoDataCopyWith<$Res> {
  factory _$NoDataCopyWith(_NoData value, $Res Function(_NoData) then) =
      __$NoDataCopyWithImpl<$Res>;
  $Res call({String query, TweetSearchFilter? filter});
}

/// @nodoc
class __$NoDataCopyWithImpl<$Res>
    extends _$NewTweetSearchStateCopyWithImpl<$Res>
    implements _$NoDataCopyWith<$Res> {
  __$NoDataCopyWithImpl(_NoData _value, $Res Function(_NoData) _then)
      : super(_value, (v) => _then(v as _NoData));

  @override
  _NoData get _value => super._value as _NoData;

  @override
  $Res call({
    Object? query = freezed,
    Object? filter = freezed,
  }) {
    return _then(_NoData(
      query: query == freezed
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
      filter: filter == freezed
          ? _value.filter
          : filter // ignore: cast_nullable_to_non_nullable
              as TweetSearchFilter?,
    ));
  }
}

/// @nodoc

class _$_NoData implements _NoData {
  const _$_NoData({required this.query, this.filter});

  @override
  final String query;
  @override
  final TweetSearchFilter? filter;

  @override
  String toString() {
    return 'NewTweetSearchState.noData(query: $query, filter: $filter)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _NoData &&
            (identical(other.query, query) || other.query == query) &&
            (identical(other.filter, filter) || other.filter == filter));
  }

  @override
  int get hashCode => Object.hash(runtimeType, query, filter);

  @JsonKey(ignore: true)
  @override
  _$NoDataCopyWith<_NoData> get copyWith =>
      __$NoDataCopyWithImpl<_NoData>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(BuiltList<TweetData> tweets, String query,
            TweetSearchFilter? filter)
        data,
    required TResult Function(String query, TweetSearchFilter? filter) noData,
    required TResult Function(String query) loading,
    required TResult Function(String query, TweetSearchFilter? filter) error,
  }) {
    return noData(query, filter);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(BuiltList<TweetData> tweets, String query,
            TweetSearchFilter? filter)?
        data,
    TResult Function(String query, TweetSearchFilter? filter)? noData,
    TResult Function(String query)? loading,
    TResult Function(String query, TweetSearchFilter? filter)? error,
  }) {
    return noData?.call(query, filter);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(BuiltList<TweetData> tweets, String query,
            TweetSearchFilter? filter)?
        data,
    TResult Function(String query, TweetSearchFilter? filter)? noData,
    TResult Function(String query)? loading,
    TResult Function(String query, TweetSearchFilter? filter)? error,
    required TResult orElse(),
  }) {
    if (noData != null) {
      return noData(query, filter);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Data value) data,
    required TResult Function(_NoData value) noData,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Error value) error,
  }) {
    return noData(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Data value)? data,
    TResult Function(_NoData value)? noData,
    TResult Function(_Loading value)? loading,
    TResult Function(_Error value)? error,
  }) {
    return noData?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Data value)? data,
    TResult Function(_NoData value)? noData,
    TResult Function(_Loading value)? loading,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (noData != null) {
      return noData(this);
    }
    return orElse();
  }
}

abstract class _NoData implements NewTweetSearchState {
  const factory _NoData({required String query, TweetSearchFilter? filter}) =
      _$_NoData;

  String get query;
  TweetSearchFilter? get filter;
  @JsonKey(ignore: true)
  _$NoDataCopyWith<_NoData> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$LoadingCopyWith<$Res> {
  factory _$LoadingCopyWith(_Loading value, $Res Function(_Loading) then) =
      __$LoadingCopyWithImpl<$Res>;
  $Res call({String query});
}

/// @nodoc
class __$LoadingCopyWithImpl<$Res>
    extends _$NewTweetSearchStateCopyWithImpl<$Res>
    implements _$LoadingCopyWith<$Res> {
  __$LoadingCopyWithImpl(_Loading _value, $Res Function(_Loading) _then)
      : super(_value, (v) => _then(v as _Loading));

  @override
  _Loading get _value => super._value as _Loading;

  @override
  $Res call({
    Object? query = freezed,
  }) {
    return _then(_Loading(
      query: query == freezed
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_Loading implements _Loading {
  const _$_Loading({required this.query});

  @override
  final String query;

  @override
  String toString() {
    return 'NewTweetSearchState.loading(query: $query)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Loading &&
            (identical(other.query, query) || other.query == query));
  }

  @override
  int get hashCode => Object.hash(runtimeType, query);

  @JsonKey(ignore: true)
  @override
  _$LoadingCopyWith<_Loading> get copyWith =>
      __$LoadingCopyWithImpl<_Loading>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(BuiltList<TweetData> tweets, String query,
            TweetSearchFilter? filter)
        data,
    required TResult Function(String query, TweetSearchFilter? filter) noData,
    required TResult Function(String query) loading,
    required TResult Function(String query, TweetSearchFilter? filter) error,
  }) {
    return loading(query);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(BuiltList<TweetData> tweets, String query,
            TweetSearchFilter? filter)?
        data,
    TResult Function(String query, TweetSearchFilter? filter)? noData,
    TResult Function(String query)? loading,
    TResult Function(String query, TweetSearchFilter? filter)? error,
  }) {
    return loading?.call(query);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(BuiltList<TweetData> tweets, String query,
            TweetSearchFilter? filter)?
        data,
    TResult Function(String query, TweetSearchFilter? filter)? noData,
    TResult Function(String query)? loading,
    TResult Function(String query, TweetSearchFilter? filter)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(query);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Data value) data,
    required TResult Function(_NoData value) noData,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Error value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Data value)? data,
    TResult Function(_NoData value)? noData,
    TResult Function(_Loading value)? loading,
    TResult Function(_Error value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Data value)? data,
    TResult Function(_NoData value)? noData,
    TResult Function(_Loading value)? loading,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _Loading implements NewTweetSearchState {
  const factory _Loading({required String query}) = _$_Loading;

  String get query;
  @JsonKey(ignore: true)
  _$LoadingCopyWith<_Loading> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$ErrorCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) then) =
      __$ErrorCopyWithImpl<$Res>;
  $Res call({String query, TweetSearchFilter? filter});
}

/// @nodoc
class __$ErrorCopyWithImpl<$Res> extends _$NewTweetSearchStateCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(_Error _value, $Res Function(_Error) _then)
      : super(_value, (v) => _then(v as _Error));

  @override
  _Error get _value => super._value as _Error;

  @override
  $Res call({
    Object? query = freezed,
    Object? filter = freezed,
  }) {
    return _then(_Error(
      query: query == freezed
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
      filter: filter == freezed
          ? _value.filter
          : filter // ignore: cast_nullable_to_non_nullable
              as TweetSearchFilter?,
    ));
  }
}

/// @nodoc

class _$_Error implements _Error {
  const _$_Error({required this.query, this.filter});

  @override
  final String query;
  @override
  final TweetSearchFilter? filter;

  @override
  String toString() {
    return 'NewTweetSearchState.error(query: $query, filter: $filter)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Error &&
            (identical(other.query, query) || other.query == query) &&
            (identical(other.filter, filter) || other.filter == filter));
  }

  @override
  int get hashCode => Object.hash(runtimeType, query, filter);

  @JsonKey(ignore: true)
  @override
  _$ErrorCopyWith<_Error> get copyWith =>
      __$ErrorCopyWithImpl<_Error>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(BuiltList<TweetData> tweets, String query,
            TweetSearchFilter? filter)
        data,
    required TResult Function(String query, TweetSearchFilter? filter) noData,
    required TResult Function(String query) loading,
    required TResult Function(String query, TweetSearchFilter? filter) error,
  }) {
    return error(query, filter);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(BuiltList<TweetData> tweets, String query,
            TweetSearchFilter? filter)?
        data,
    TResult Function(String query, TweetSearchFilter? filter)? noData,
    TResult Function(String query)? loading,
    TResult Function(String query, TweetSearchFilter? filter)? error,
  }) {
    return error?.call(query, filter);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(BuiltList<TweetData> tweets, String query,
            TweetSearchFilter? filter)?
        data,
    TResult Function(String query, TweetSearchFilter? filter)? noData,
    TResult Function(String query)? loading,
    TResult Function(String query, TweetSearchFilter? filter)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(query, filter);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Data value) data,
    required TResult Function(_NoData value) noData,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Error value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Data value)? data,
    TResult Function(_NoData value)? noData,
    TResult Function(_Loading value)? loading,
    TResult Function(_Error value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Data value)? data,
    TResult Function(_NoData value)? noData,
    TResult Function(_Loading value)? loading,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _Error implements NewTweetSearchState {
  const factory _Error({required String query, TweetSearchFilter? filter}) =
      _$_Error;

  String get query;
  TweetSearchFilter? get filter;
  @JsonKey(ignore: true)
  _$ErrorCopyWith<_Error> get copyWith => throw _privateConstructorUsedError;
}
