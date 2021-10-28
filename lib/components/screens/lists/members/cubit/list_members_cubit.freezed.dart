// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'list_members_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$ListMembersStateTearOff {
  const _$ListMembersStateTearOff();

  _ListMembersStateData data(
      {required BuiltList<UserData> members, required String? membersCursor}) {
    return _ListMembersStateData(
      members: members,
      membersCursor: membersCursor,
    );
  }

  _ListMembersStateLoadingMore loadingMore(
      {required BuiltList<UserData> members}) {
    return _ListMembersStateLoadingMore(
      members: members,
    );
  }

  _ListMembersStateLoading loading() {
    return const _ListMembersStateLoading();
  }

  _ListMembersStateError error() {
    return const _ListMembersStateError();
  }

  _ListMembersStateNoData noData() {
    return const _ListMembersStateNoData();
  }
}

/// @nodoc
const $ListMembersState = _$ListMembersStateTearOff();

/// @nodoc
mixin _$ListMembersState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            BuiltList<UserData> members, String? membersCursor)
        data,
    required TResult Function(BuiltList<UserData> members) loadingMore,
    required TResult Function() loading,
    required TResult Function() error,
    required TResult Function() noData,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(BuiltList<UserData> members, String? membersCursor)? data,
    TResult Function(BuiltList<UserData> members)? loadingMore,
    TResult Function()? loading,
    TResult Function()? error,
    TResult Function()? noData,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BuiltList<UserData> members, String? membersCursor)? data,
    TResult Function(BuiltList<UserData> members)? loadingMore,
    TResult Function()? loading,
    TResult Function()? error,
    TResult Function()? noData,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ListMembersStateData value) data,
    required TResult Function(_ListMembersStateLoadingMore value) loadingMore,
    required TResult Function(_ListMembersStateLoading value) loading,
    required TResult Function(_ListMembersStateError value) error,
    required TResult Function(_ListMembersStateNoData value) noData,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_ListMembersStateData value)? data,
    TResult Function(_ListMembersStateLoadingMore value)? loadingMore,
    TResult Function(_ListMembersStateLoading value)? loading,
    TResult Function(_ListMembersStateError value)? error,
    TResult Function(_ListMembersStateNoData value)? noData,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ListMembersStateData value)? data,
    TResult Function(_ListMembersStateLoadingMore value)? loadingMore,
    TResult Function(_ListMembersStateLoading value)? loading,
    TResult Function(_ListMembersStateError value)? error,
    TResult Function(_ListMembersStateNoData value)? noData,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ListMembersStateCopyWith<$Res> {
  factory $ListMembersStateCopyWith(
          ListMembersState value, $Res Function(ListMembersState) then) =
      _$ListMembersStateCopyWithImpl<$Res>;
}

/// @nodoc
class _$ListMembersStateCopyWithImpl<$Res>
    implements $ListMembersStateCopyWith<$Res> {
  _$ListMembersStateCopyWithImpl(this._value, this._then);

  final ListMembersState _value;
  // ignore: unused_field
  final $Res Function(ListMembersState) _then;
}

/// @nodoc
abstract class _$ListMembersStateDataCopyWith<$Res> {
  factory _$ListMembersStateDataCopyWith(_ListMembersStateData value,
          $Res Function(_ListMembersStateData) then) =
      __$ListMembersStateDataCopyWithImpl<$Res>;
  $Res call({BuiltList<UserData> members, String? membersCursor});
}

/// @nodoc
class __$ListMembersStateDataCopyWithImpl<$Res>
    extends _$ListMembersStateCopyWithImpl<$Res>
    implements _$ListMembersStateDataCopyWith<$Res> {
  __$ListMembersStateDataCopyWithImpl(
      _ListMembersStateData _value, $Res Function(_ListMembersStateData) _then)
      : super(_value, (v) => _then(v as _ListMembersStateData));

  @override
  _ListMembersStateData get _value => super._value as _ListMembersStateData;

  @override
  $Res call({
    Object? members = freezed,
    Object? membersCursor = freezed,
  }) {
    return _then(_ListMembersStateData(
      members: members == freezed
          ? _value.members
          : members // ignore: cast_nullable_to_non_nullable
              as BuiltList<UserData>,
      membersCursor: membersCursor == freezed
          ? _value.membersCursor
          : membersCursor // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_ListMembersStateData implements _ListMembersStateData {
  const _$_ListMembersStateData(
      {required this.members, required this.membersCursor});

  @override
  final BuiltList<UserData> members;
  @override
  final String? membersCursor;

  @override
  String toString() {
    return 'ListMembersState.data(members: $members, membersCursor: $membersCursor)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ListMembersStateData &&
            (identical(other.members, members) || other.members == members) &&
            (identical(other.membersCursor, membersCursor) ||
                other.membersCursor == membersCursor));
  }

  @override
  int get hashCode => Object.hash(runtimeType, members, membersCursor);

  @JsonKey(ignore: true)
  @override
  _$ListMembersStateDataCopyWith<_ListMembersStateData> get copyWith =>
      __$ListMembersStateDataCopyWithImpl<_ListMembersStateData>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            BuiltList<UserData> members, String? membersCursor)
        data,
    required TResult Function(BuiltList<UserData> members) loadingMore,
    required TResult Function() loading,
    required TResult Function() error,
    required TResult Function() noData,
  }) {
    return data(members, membersCursor);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(BuiltList<UserData> members, String? membersCursor)? data,
    TResult Function(BuiltList<UserData> members)? loadingMore,
    TResult Function()? loading,
    TResult Function()? error,
    TResult Function()? noData,
  }) {
    return data?.call(members, membersCursor);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BuiltList<UserData> members, String? membersCursor)? data,
    TResult Function(BuiltList<UserData> members)? loadingMore,
    TResult Function()? loading,
    TResult Function()? error,
    TResult Function()? noData,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(members, membersCursor);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ListMembersStateData value) data,
    required TResult Function(_ListMembersStateLoadingMore value) loadingMore,
    required TResult Function(_ListMembersStateLoading value) loading,
    required TResult Function(_ListMembersStateError value) error,
    required TResult Function(_ListMembersStateNoData value) noData,
  }) {
    return data(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_ListMembersStateData value)? data,
    TResult Function(_ListMembersStateLoadingMore value)? loadingMore,
    TResult Function(_ListMembersStateLoading value)? loading,
    TResult Function(_ListMembersStateError value)? error,
    TResult Function(_ListMembersStateNoData value)? noData,
  }) {
    return data?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ListMembersStateData value)? data,
    TResult Function(_ListMembersStateLoadingMore value)? loadingMore,
    TResult Function(_ListMembersStateLoading value)? loading,
    TResult Function(_ListMembersStateError value)? error,
    TResult Function(_ListMembersStateNoData value)? noData,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(this);
    }
    return orElse();
  }
}

abstract class _ListMembersStateData implements ListMembersState {
  const factory _ListMembersStateData(
      {required BuiltList<UserData> members,
      required String? membersCursor}) = _$_ListMembersStateData;

  BuiltList<UserData> get members;
  String? get membersCursor;
  @JsonKey(ignore: true)
  _$ListMembersStateDataCopyWith<_ListMembersStateData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$ListMembersStateLoadingMoreCopyWith<$Res> {
  factory _$ListMembersStateLoadingMoreCopyWith(
          _ListMembersStateLoadingMore value,
          $Res Function(_ListMembersStateLoadingMore) then) =
      __$ListMembersStateLoadingMoreCopyWithImpl<$Res>;
  $Res call({BuiltList<UserData> members});
}

/// @nodoc
class __$ListMembersStateLoadingMoreCopyWithImpl<$Res>
    extends _$ListMembersStateCopyWithImpl<$Res>
    implements _$ListMembersStateLoadingMoreCopyWith<$Res> {
  __$ListMembersStateLoadingMoreCopyWithImpl(
      _ListMembersStateLoadingMore _value,
      $Res Function(_ListMembersStateLoadingMore) _then)
      : super(_value, (v) => _then(v as _ListMembersStateLoadingMore));

  @override
  _ListMembersStateLoadingMore get _value =>
      super._value as _ListMembersStateLoadingMore;

  @override
  $Res call({
    Object? members = freezed,
  }) {
    return _then(_ListMembersStateLoadingMore(
      members: members == freezed
          ? _value.members
          : members // ignore: cast_nullable_to_non_nullable
              as BuiltList<UserData>,
    ));
  }
}

/// @nodoc

class _$_ListMembersStateLoadingMore implements _ListMembersStateLoadingMore {
  const _$_ListMembersStateLoadingMore({required this.members});

  @override
  final BuiltList<UserData> members;

  @override
  String toString() {
    return 'ListMembersState.loadingMore(members: $members)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ListMembersStateLoadingMore &&
            (identical(other.members, members) || other.members == members));
  }

  @override
  int get hashCode => Object.hash(runtimeType, members);

  @JsonKey(ignore: true)
  @override
  _$ListMembersStateLoadingMoreCopyWith<_ListMembersStateLoadingMore>
      get copyWith => __$ListMembersStateLoadingMoreCopyWithImpl<
          _ListMembersStateLoadingMore>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            BuiltList<UserData> members, String? membersCursor)
        data,
    required TResult Function(BuiltList<UserData> members) loadingMore,
    required TResult Function() loading,
    required TResult Function() error,
    required TResult Function() noData,
  }) {
    return loadingMore(members);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(BuiltList<UserData> members, String? membersCursor)? data,
    TResult Function(BuiltList<UserData> members)? loadingMore,
    TResult Function()? loading,
    TResult Function()? error,
    TResult Function()? noData,
  }) {
    return loadingMore?.call(members);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BuiltList<UserData> members, String? membersCursor)? data,
    TResult Function(BuiltList<UserData> members)? loadingMore,
    TResult Function()? loading,
    TResult Function()? error,
    TResult Function()? noData,
    required TResult orElse(),
  }) {
    if (loadingMore != null) {
      return loadingMore(members);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ListMembersStateData value) data,
    required TResult Function(_ListMembersStateLoadingMore value) loadingMore,
    required TResult Function(_ListMembersStateLoading value) loading,
    required TResult Function(_ListMembersStateError value) error,
    required TResult Function(_ListMembersStateNoData value) noData,
  }) {
    return loadingMore(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_ListMembersStateData value)? data,
    TResult Function(_ListMembersStateLoadingMore value)? loadingMore,
    TResult Function(_ListMembersStateLoading value)? loading,
    TResult Function(_ListMembersStateError value)? error,
    TResult Function(_ListMembersStateNoData value)? noData,
  }) {
    return loadingMore?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ListMembersStateData value)? data,
    TResult Function(_ListMembersStateLoadingMore value)? loadingMore,
    TResult Function(_ListMembersStateLoading value)? loading,
    TResult Function(_ListMembersStateError value)? error,
    TResult Function(_ListMembersStateNoData value)? noData,
    required TResult orElse(),
  }) {
    if (loadingMore != null) {
      return loadingMore(this);
    }
    return orElse();
  }
}

abstract class _ListMembersStateLoadingMore implements ListMembersState {
  const factory _ListMembersStateLoadingMore(
      {required BuiltList<UserData> members}) = _$_ListMembersStateLoadingMore;

  BuiltList<UserData> get members;
  @JsonKey(ignore: true)
  _$ListMembersStateLoadingMoreCopyWith<_ListMembersStateLoadingMore>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$ListMembersStateLoadingCopyWith<$Res> {
  factory _$ListMembersStateLoadingCopyWith(_ListMembersStateLoading value,
          $Res Function(_ListMembersStateLoading) then) =
      __$ListMembersStateLoadingCopyWithImpl<$Res>;
}

/// @nodoc
class __$ListMembersStateLoadingCopyWithImpl<$Res>
    extends _$ListMembersStateCopyWithImpl<$Res>
    implements _$ListMembersStateLoadingCopyWith<$Res> {
  __$ListMembersStateLoadingCopyWithImpl(_ListMembersStateLoading _value,
      $Res Function(_ListMembersStateLoading) _then)
      : super(_value, (v) => _then(v as _ListMembersStateLoading));

  @override
  _ListMembersStateLoading get _value =>
      super._value as _ListMembersStateLoading;
}

/// @nodoc

class _$_ListMembersStateLoading implements _ListMembersStateLoading {
  const _$_ListMembersStateLoading();

  @override
  String toString() {
    return 'ListMembersState.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _ListMembersStateLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            BuiltList<UserData> members, String? membersCursor)
        data,
    required TResult Function(BuiltList<UserData> members) loadingMore,
    required TResult Function() loading,
    required TResult Function() error,
    required TResult Function() noData,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(BuiltList<UserData> members, String? membersCursor)? data,
    TResult Function(BuiltList<UserData> members)? loadingMore,
    TResult Function()? loading,
    TResult Function()? error,
    TResult Function()? noData,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BuiltList<UserData> members, String? membersCursor)? data,
    TResult Function(BuiltList<UserData> members)? loadingMore,
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
    required TResult Function(_ListMembersStateData value) data,
    required TResult Function(_ListMembersStateLoadingMore value) loadingMore,
    required TResult Function(_ListMembersStateLoading value) loading,
    required TResult Function(_ListMembersStateError value) error,
    required TResult Function(_ListMembersStateNoData value) noData,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_ListMembersStateData value)? data,
    TResult Function(_ListMembersStateLoadingMore value)? loadingMore,
    TResult Function(_ListMembersStateLoading value)? loading,
    TResult Function(_ListMembersStateError value)? error,
    TResult Function(_ListMembersStateNoData value)? noData,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ListMembersStateData value)? data,
    TResult Function(_ListMembersStateLoadingMore value)? loadingMore,
    TResult Function(_ListMembersStateLoading value)? loading,
    TResult Function(_ListMembersStateError value)? error,
    TResult Function(_ListMembersStateNoData value)? noData,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _ListMembersStateLoading implements ListMembersState {
  const factory _ListMembersStateLoading() = _$_ListMembersStateLoading;
}

/// @nodoc
abstract class _$ListMembersStateErrorCopyWith<$Res> {
  factory _$ListMembersStateErrorCopyWith(_ListMembersStateError value,
          $Res Function(_ListMembersStateError) then) =
      __$ListMembersStateErrorCopyWithImpl<$Res>;
}

/// @nodoc
class __$ListMembersStateErrorCopyWithImpl<$Res>
    extends _$ListMembersStateCopyWithImpl<$Res>
    implements _$ListMembersStateErrorCopyWith<$Res> {
  __$ListMembersStateErrorCopyWithImpl(_ListMembersStateError _value,
      $Res Function(_ListMembersStateError) _then)
      : super(_value, (v) => _then(v as _ListMembersStateError));

  @override
  _ListMembersStateError get _value => super._value as _ListMembersStateError;
}

/// @nodoc

class _$_ListMembersStateError implements _ListMembersStateError {
  const _$_ListMembersStateError();

  @override
  String toString() {
    return 'ListMembersState.error()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _ListMembersStateError);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            BuiltList<UserData> members, String? membersCursor)
        data,
    required TResult Function(BuiltList<UserData> members) loadingMore,
    required TResult Function() loading,
    required TResult Function() error,
    required TResult Function() noData,
  }) {
    return error();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(BuiltList<UserData> members, String? membersCursor)? data,
    TResult Function(BuiltList<UserData> members)? loadingMore,
    TResult Function()? loading,
    TResult Function()? error,
    TResult Function()? noData,
  }) {
    return error?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BuiltList<UserData> members, String? membersCursor)? data,
    TResult Function(BuiltList<UserData> members)? loadingMore,
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
    required TResult Function(_ListMembersStateData value) data,
    required TResult Function(_ListMembersStateLoadingMore value) loadingMore,
    required TResult Function(_ListMembersStateLoading value) loading,
    required TResult Function(_ListMembersStateError value) error,
    required TResult Function(_ListMembersStateNoData value) noData,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_ListMembersStateData value)? data,
    TResult Function(_ListMembersStateLoadingMore value)? loadingMore,
    TResult Function(_ListMembersStateLoading value)? loading,
    TResult Function(_ListMembersStateError value)? error,
    TResult Function(_ListMembersStateNoData value)? noData,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ListMembersStateData value)? data,
    TResult Function(_ListMembersStateLoadingMore value)? loadingMore,
    TResult Function(_ListMembersStateLoading value)? loading,
    TResult Function(_ListMembersStateError value)? error,
    TResult Function(_ListMembersStateNoData value)? noData,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _ListMembersStateError implements ListMembersState {
  const factory _ListMembersStateError() = _$_ListMembersStateError;
}

/// @nodoc
abstract class _$ListMembersStateNoDataCopyWith<$Res> {
  factory _$ListMembersStateNoDataCopyWith(_ListMembersStateNoData value,
          $Res Function(_ListMembersStateNoData) then) =
      __$ListMembersStateNoDataCopyWithImpl<$Res>;
}

/// @nodoc
class __$ListMembersStateNoDataCopyWithImpl<$Res>
    extends _$ListMembersStateCopyWithImpl<$Res>
    implements _$ListMembersStateNoDataCopyWith<$Res> {
  __$ListMembersStateNoDataCopyWithImpl(_ListMembersStateNoData _value,
      $Res Function(_ListMembersStateNoData) _then)
      : super(_value, (v) => _then(v as _ListMembersStateNoData));

  @override
  _ListMembersStateNoData get _value => super._value as _ListMembersStateNoData;
}

/// @nodoc

class _$_ListMembersStateNoData implements _ListMembersStateNoData {
  const _$_ListMembersStateNoData();

  @override
  String toString() {
    return 'ListMembersState.noData()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _ListMembersStateNoData);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            BuiltList<UserData> members, String? membersCursor)
        data,
    required TResult Function(BuiltList<UserData> members) loadingMore,
    required TResult Function() loading,
    required TResult Function() error,
    required TResult Function() noData,
  }) {
    return noData();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(BuiltList<UserData> members, String? membersCursor)? data,
    TResult Function(BuiltList<UserData> members)? loadingMore,
    TResult Function()? loading,
    TResult Function()? error,
    TResult Function()? noData,
  }) {
    return noData?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BuiltList<UserData> members, String? membersCursor)? data,
    TResult Function(BuiltList<UserData> members)? loadingMore,
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
    required TResult Function(_ListMembersStateData value) data,
    required TResult Function(_ListMembersStateLoadingMore value) loadingMore,
    required TResult Function(_ListMembersStateLoading value) loading,
    required TResult Function(_ListMembersStateError value) error,
    required TResult Function(_ListMembersStateNoData value) noData,
  }) {
    return noData(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_ListMembersStateData value)? data,
    TResult Function(_ListMembersStateLoadingMore value)? loadingMore,
    TResult Function(_ListMembersStateLoading value)? loading,
    TResult Function(_ListMembersStateError value)? error,
    TResult Function(_ListMembersStateNoData value)? noData,
  }) {
    return noData?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ListMembersStateData value)? data,
    TResult Function(_ListMembersStateLoadingMore value)? loadingMore,
    TResult Function(_ListMembersStateLoading value)? loading,
    TResult Function(_ListMembersStateError value)? error,
    TResult Function(_ListMembersStateNoData value)? noData,
    required TResult orElse(),
  }) {
    if (noData != null) {
      return noData(this);
    }
    return orElse();
  }
}

abstract class _ListMembersStateNoData implements ListMembersState {
  const factory _ListMembersStateNoData() = _$_ListMembersStateNoData;
}
