// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'user_search_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$UsersSearchStateDataTearOff {
  const _$UsersSearchStateDataTearOff();

  _UsersSearchStateData call(
      {required BuiltList<UserData> users, required String query}) {
    return _UsersSearchStateData(
      users: users,
      query: query,
    );
  }
}

/// @nodoc
const $UsersSearchStateData = _$UsersSearchStateDataTearOff();

/// @nodoc
mixin _$UsersSearchStateData {
  BuiltList<UserData> get users => throw _privateConstructorUsedError;
  String get query => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UsersSearchStateDataCopyWith<UsersSearchStateData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UsersSearchStateDataCopyWith<$Res> {
  factory $UsersSearchStateDataCopyWith(UsersSearchStateData value,
          $Res Function(UsersSearchStateData) then) =
      _$UsersSearchStateDataCopyWithImpl<$Res>;
  $Res call({BuiltList<UserData> users, String query});
}

/// @nodoc
class _$UsersSearchStateDataCopyWithImpl<$Res>
    implements $UsersSearchStateDataCopyWith<$Res> {
  _$UsersSearchStateDataCopyWithImpl(this._value, this._then);

  final UsersSearchStateData _value;
  // ignore: unused_field
  final $Res Function(UsersSearchStateData) _then;

  @override
  $Res call({
    Object? users = freezed,
    Object? query = freezed,
  }) {
    return _then(_value.copyWith(
      users: users == freezed
          ? _value.users
          : users // ignore: cast_nullable_to_non_nullable
              as BuiltList<UserData>,
      query: query == freezed
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$UsersSearchStateDataCopyWith<$Res>
    implements $UsersSearchStateDataCopyWith<$Res> {
  factory _$UsersSearchStateDataCopyWith(_UsersSearchStateData value,
          $Res Function(_UsersSearchStateData) then) =
      __$UsersSearchStateDataCopyWithImpl<$Res>;
  @override
  $Res call({BuiltList<UserData> users, String query});
}

/// @nodoc
class __$UsersSearchStateDataCopyWithImpl<$Res>
    extends _$UsersSearchStateDataCopyWithImpl<$Res>
    implements _$UsersSearchStateDataCopyWith<$Res> {
  __$UsersSearchStateDataCopyWithImpl(
      _UsersSearchStateData _value, $Res Function(_UsersSearchStateData) _then)
      : super(_value, (v) => _then(v as _UsersSearchStateData));

  @override
  _UsersSearchStateData get _value => super._value as _UsersSearchStateData;

  @override
  $Res call({
    Object? users = freezed,
    Object? query = freezed,
  }) {
    return _then(_UsersSearchStateData(
      users: users == freezed
          ? _value.users
          : users // ignore: cast_nullable_to_non_nullable
              as BuiltList<UserData>,
      query: query == freezed
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_UsersSearchStateData implements _UsersSearchStateData {
  const _$_UsersSearchStateData({required this.users, required this.query});

  @override
  final BuiltList<UserData> users;
  @override
  final String query;

  @override
  String toString() {
    return 'UsersSearchStateData(users: $users, query: $query)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UsersSearchStateData &&
            (identical(other.users, users) || other.users == users) &&
            (identical(other.query, query) || other.query == query));
  }

  @override
  int get hashCode => Object.hash(runtimeType, users, query);

  @JsonKey(ignore: true)
  @override
  _$UsersSearchStateDataCopyWith<_UsersSearchStateData> get copyWith =>
      __$UsersSearchStateDataCopyWithImpl<_UsersSearchStateData>(
          this, _$identity);
}

abstract class _UsersSearchStateData implements UsersSearchStateData {
  const factory _UsersSearchStateData(
      {required BuiltList<UserData> users,
      required String query}) = _$_UsersSearchStateData;

  @override
  BuiltList<UserData> get users;
  @override
  String get query;
  @override
  @JsonKey(ignore: true)
  _$UsersSearchStateDataCopyWith<_UsersSearchStateData> get copyWith =>
      throw _privateConstructorUsedError;
}
