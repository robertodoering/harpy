// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'replies_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$RepliesStateTearOff {
  const _$RepliesStateTearOff();

  _Data data({required BuiltList<TweetData> replies, TweetData? parent}) {
    return _Data(
      replies: replies,
      parent: parent,
    );
  }

  _NoData noData({TweetData? parent}) {
    return _NoData(
      parent: parent,
    );
  }

  _Error error({TweetData? parent}) {
    return _Error(
      parent: parent,
    );
  }

  _Loading loading() {
    return const _Loading();
  }
}

/// @nodoc
const $RepliesState = _$RepliesStateTearOff();

/// @nodoc
mixin _$RepliesState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BuiltList<TweetData> replies, TweetData? parent)
        data,
    required TResult Function(TweetData? parent) noData,
    required TResult Function(TweetData? parent) error,
    required TResult Function() loading,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(BuiltList<TweetData> replies, TweetData? parent)? data,
    TResult Function(TweetData? parent)? noData,
    TResult Function(TweetData? parent)? error,
    TResult Function()? loading,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BuiltList<TweetData> replies, TweetData? parent)? data,
    TResult Function(TweetData? parent)? noData,
    TResult Function(TweetData? parent)? error,
    TResult Function()? loading,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Data value) data,
    required TResult Function(_NoData value) noData,
    required TResult Function(_Error value) error,
    required TResult Function(_Loading value) loading,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_Data value)? data,
    TResult Function(_NoData value)? noData,
    TResult Function(_Error value)? error,
    TResult Function(_Loading value)? loading,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Data value)? data,
    TResult Function(_NoData value)? noData,
    TResult Function(_Error value)? error,
    TResult Function(_Loading value)? loading,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RepliesStateCopyWith<$Res> {
  factory $RepliesStateCopyWith(
          RepliesState value, $Res Function(RepliesState) then) =
      _$RepliesStateCopyWithImpl<$Res>;
}

/// @nodoc
class _$RepliesStateCopyWithImpl<$Res> implements $RepliesStateCopyWith<$Res> {
  _$RepliesStateCopyWithImpl(this._value, this._then);

  final RepliesState _value;
  // ignore: unused_field
  final $Res Function(RepliesState) _then;
}

/// @nodoc
abstract class _$DataCopyWith<$Res> {
  factory _$DataCopyWith(_Data value, $Res Function(_Data) then) =
      __$DataCopyWithImpl<$Res>;
  $Res call({BuiltList<TweetData> replies, TweetData? parent});
}

/// @nodoc
class __$DataCopyWithImpl<$Res> extends _$RepliesStateCopyWithImpl<$Res>
    implements _$DataCopyWith<$Res> {
  __$DataCopyWithImpl(_Data _value, $Res Function(_Data) _then)
      : super(_value, (v) => _then(v as _Data));

  @override
  _Data get _value => super._value as _Data;

  @override
  $Res call({
    Object? replies = freezed,
    Object? parent = freezed,
  }) {
    return _then(_Data(
      replies: replies == freezed
          ? _value.replies
          : replies // ignore: cast_nullable_to_non_nullable
              as BuiltList<TweetData>,
      parent: parent == freezed
          ? _value.parent
          : parent // ignore: cast_nullable_to_non_nullable
              as TweetData?,
    ));
  }
}

/// @nodoc

class _$_Data implements _Data {
  const _$_Data({required this.replies, this.parent});

  @override
  final BuiltList<TweetData> replies;
  @override

  /// When the tweet is a reply itself, the [parent] will contain the parent
  /// reply chain.
  final TweetData? parent;

  @override
  String toString() {
    return 'RepliesState.data(replies: $replies, parent: $parent)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Data &&
            (identical(other.replies, replies) || other.replies == replies) &&
            (identical(other.parent, parent) || other.parent == parent));
  }

  @override
  int get hashCode => Object.hash(runtimeType, replies, parent);

  @JsonKey(ignore: true)
  @override
  _$DataCopyWith<_Data> get copyWith =>
      __$DataCopyWithImpl<_Data>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BuiltList<TweetData> replies, TweetData? parent)
        data,
    required TResult Function(TweetData? parent) noData,
    required TResult Function(TweetData? parent) error,
    required TResult Function() loading,
  }) {
    return data(replies, parent);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(BuiltList<TweetData> replies, TweetData? parent)? data,
    TResult Function(TweetData? parent)? noData,
    TResult Function(TweetData? parent)? error,
    TResult Function()? loading,
  }) {
    return data?.call(replies, parent);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BuiltList<TweetData> replies, TweetData? parent)? data,
    TResult Function(TweetData? parent)? noData,
    TResult Function(TweetData? parent)? error,
    TResult Function()? loading,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(replies, parent);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Data value) data,
    required TResult Function(_NoData value) noData,
    required TResult Function(_Error value) error,
    required TResult Function(_Loading value) loading,
  }) {
    return data(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_Data value)? data,
    TResult Function(_NoData value)? noData,
    TResult Function(_Error value)? error,
    TResult Function(_Loading value)? loading,
  }) {
    return data?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Data value)? data,
    TResult Function(_NoData value)? noData,
    TResult Function(_Error value)? error,
    TResult Function(_Loading value)? loading,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(this);
    }
    return orElse();
  }
}

abstract class _Data implements RepliesState {
  const factory _Data(
      {required BuiltList<TweetData> replies, TweetData? parent}) = _$_Data;

  BuiltList<TweetData> get replies;

  /// When the tweet is a reply itself, the [parent] will contain the parent
  /// reply chain.
  TweetData? get parent;
  @JsonKey(ignore: true)
  _$DataCopyWith<_Data> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$NoDataCopyWith<$Res> {
  factory _$NoDataCopyWith(_NoData value, $Res Function(_NoData) then) =
      __$NoDataCopyWithImpl<$Res>;
  $Res call({TweetData? parent});
}

/// @nodoc
class __$NoDataCopyWithImpl<$Res> extends _$RepliesStateCopyWithImpl<$Res>
    implements _$NoDataCopyWith<$Res> {
  __$NoDataCopyWithImpl(_NoData _value, $Res Function(_NoData) _then)
      : super(_value, (v) => _then(v as _NoData));

  @override
  _NoData get _value => super._value as _NoData;

  @override
  $Res call({
    Object? parent = freezed,
  }) {
    return _then(_NoData(
      parent: parent == freezed
          ? _value.parent
          : parent // ignore: cast_nullable_to_non_nullable
              as TweetData?,
    ));
  }
}

/// @nodoc

class _$_NoData implements _NoData {
  const _$_NoData({this.parent});

  @override
  final TweetData? parent;

  @override
  String toString() {
    return 'RepliesState.noData(parent: $parent)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _NoData &&
            (identical(other.parent, parent) || other.parent == parent));
  }

  @override
  int get hashCode => Object.hash(runtimeType, parent);

  @JsonKey(ignore: true)
  @override
  _$NoDataCopyWith<_NoData> get copyWith =>
      __$NoDataCopyWithImpl<_NoData>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BuiltList<TweetData> replies, TweetData? parent)
        data,
    required TResult Function(TweetData? parent) noData,
    required TResult Function(TweetData? parent) error,
    required TResult Function() loading,
  }) {
    return noData(parent);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(BuiltList<TweetData> replies, TweetData? parent)? data,
    TResult Function(TweetData? parent)? noData,
    TResult Function(TweetData? parent)? error,
    TResult Function()? loading,
  }) {
    return noData?.call(parent);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BuiltList<TweetData> replies, TweetData? parent)? data,
    TResult Function(TweetData? parent)? noData,
    TResult Function(TweetData? parent)? error,
    TResult Function()? loading,
    required TResult orElse(),
  }) {
    if (noData != null) {
      return noData(parent);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Data value) data,
    required TResult Function(_NoData value) noData,
    required TResult Function(_Error value) error,
    required TResult Function(_Loading value) loading,
  }) {
    return noData(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_Data value)? data,
    TResult Function(_NoData value)? noData,
    TResult Function(_Error value)? error,
    TResult Function(_Loading value)? loading,
  }) {
    return noData?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Data value)? data,
    TResult Function(_NoData value)? noData,
    TResult Function(_Error value)? error,
    TResult Function(_Loading value)? loading,
    required TResult orElse(),
  }) {
    if (noData != null) {
      return noData(this);
    }
    return orElse();
  }
}

abstract class _NoData implements RepliesState {
  const factory _NoData({TweetData? parent}) = _$_NoData;

  TweetData? get parent;
  @JsonKey(ignore: true)
  _$NoDataCopyWith<_NoData> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$ErrorCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) then) =
      __$ErrorCopyWithImpl<$Res>;
  $Res call({TweetData? parent});
}

/// @nodoc
class __$ErrorCopyWithImpl<$Res> extends _$RepliesStateCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(_Error _value, $Res Function(_Error) _then)
      : super(_value, (v) => _then(v as _Error));

  @override
  _Error get _value => super._value as _Error;

  @override
  $Res call({
    Object? parent = freezed,
  }) {
    return _then(_Error(
      parent: parent == freezed
          ? _value.parent
          : parent // ignore: cast_nullable_to_non_nullable
              as TweetData?,
    ));
  }
}

/// @nodoc

class _$_Error implements _Error {
  const _$_Error({this.parent});

  @override
  final TweetData? parent;

  @override
  String toString() {
    return 'RepliesState.error(parent: $parent)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Error &&
            (identical(other.parent, parent) || other.parent == parent));
  }

  @override
  int get hashCode => Object.hash(runtimeType, parent);

  @JsonKey(ignore: true)
  @override
  _$ErrorCopyWith<_Error> get copyWith =>
      __$ErrorCopyWithImpl<_Error>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BuiltList<TweetData> replies, TweetData? parent)
        data,
    required TResult Function(TweetData? parent) noData,
    required TResult Function(TweetData? parent) error,
    required TResult Function() loading,
  }) {
    return error(parent);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(BuiltList<TweetData> replies, TweetData? parent)? data,
    TResult Function(TweetData? parent)? noData,
    TResult Function(TweetData? parent)? error,
    TResult Function()? loading,
  }) {
    return error?.call(parent);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BuiltList<TweetData> replies, TweetData? parent)? data,
    TResult Function(TweetData? parent)? noData,
    TResult Function(TweetData? parent)? error,
    TResult Function()? loading,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(parent);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Data value) data,
    required TResult Function(_NoData value) noData,
    required TResult Function(_Error value) error,
    required TResult Function(_Loading value) loading,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_Data value)? data,
    TResult Function(_NoData value)? noData,
    TResult Function(_Error value)? error,
    TResult Function(_Loading value)? loading,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Data value)? data,
    TResult Function(_NoData value)? noData,
    TResult Function(_Error value)? error,
    TResult Function(_Loading value)? loading,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _Error implements RepliesState {
  const factory _Error({TweetData? parent}) = _$_Error;

  TweetData? get parent;
  @JsonKey(ignore: true)
  _$ErrorCopyWith<_Error> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$LoadingCopyWith<$Res> {
  factory _$LoadingCopyWith(_Loading value, $Res Function(_Loading) then) =
      __$LoadingCopyWithImpl<$Res>;
}

/// @nodoc
class __$LoadingCopyWithImpl<$Res> extends _$RepliesStateCopyWithImpl<$Res>
    implements _$LoadingCopyWith<$Res> {
  __$LoadingCopyWithImpl(_Loading _value, $Res Function(_Loading) _then)
      : super(_value, (v) => _then(v as _Loading));

  @override
  _Loading get _value => super._value as _Loading;
}

/// @nodoc

class _$_Loading implements _Loading {
  const _$_Loading();

  @override
  String toString() {
    return 'RepliesState.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _Loading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BuiltList<TweetData> replies, TweetData? parent)
        data,
    required TResult Function(TweetData? parent) noData,
    required TResult Function(TweetData? parent) error,
    required TResult Function() loading,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(BuiltList<TweetData> replies, TweetData? parent)? data,
    TResult Function(TweetData? parent)? noData,
    TResult Function(TweetData? parent)? error,
    TResult Function()? loading,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BuiltList<TweetData> replies, TweetData? parent)? data,
    TResult Function(TweetData? parent)? noData,
    TResult Function(TweetData? parent)? error,
    TResult Function()? loading,
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
    required TResult Function(_Data value) data,
    required TResult Function(_NoData value) noData,
    required TResult Function(_Error value) error,
    required TResult Function(_Loading value) loading,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_Data value)? data,
    TResult Function(_NoData value)? noData,
    TResult Function(_Error value)? error,
    TResult Function(_Loading value)? loading,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Data value)? data,
    TResult Function(_NoData value)? noData,
    TResult Function(_Error value)? error,
    TResult Function(_Loading value)? loading,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _Loading implements RepliesState {
  const factory _Loading() = _$_Loading;
}
