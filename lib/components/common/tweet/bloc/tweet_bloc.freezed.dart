// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'tweet_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$TweetStateTearOff {
  const _$TweetStateTearOff();

  _State call(
      {required bool retweeted,
      required bool favorited,
      required bool translated,
      required bool isTranslating}) {
    return _State(
      retweeted: retweeted,
      favorited: favorited,
      translated: translated,
      isTranslating: isTranslating,
    );
  }
}

/// @nodoc
const $TweetState = _$TweetStateTearOff();

/// @nodoc
mixin _$TweetState {
  bool get retweeted => throw _privateConstructorUsedError;
  bool get favorited => throw _privateConstructorUsedError;
  bool get translated => throw _privateConstructorUsedError;
  bool get isTranslating => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TweetStateCopyWith<TweetState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TweetStateCopyWith<$Res> {
  factory $TweetStateCopyWith(
          TweetState value, $Res Function(TweetState) then) =
      _$TweetStateCopyWithImpl<$Res>;
  $Res call(
      {bool retweeted, bool favorited, bool translated, bool isTranslating});
}

/// @nodoc
class _$TweetStateCopyWithImpl<$Res> implements $TweetStateCopyWith<$Res> {
  _$TweetStateCopyWithImpl(this._value, this._then);

  final TweetState _value;
  // ignore: unused_field
  final $Res Function(TweetState) _then;

  @override
  $Res call({
    Object? retweeted = freezed,
    Object? favorited = freezed,
    Object? translated = freezed,
    Object? isTranslating = freezed,
  }) {
    return _then(_value.copyWith(
      retweeted: retweeted == freezed
          ? _value.retweeted
          : retweeted // ignore: cast_nullable_to_non_nullable
              as bool,
      favorited: favorited == freezed
          ? _value.favorited
          : favorited // ignore: cast_nullable_to_non_nullable
              as bool,
      translated: translated == freezed
          ? _value.translated
          : translated // ignore: cast_nullable_to_non_nullable
              as bool,
      isTranslating: isTranslating == freezed
          ? _value.isTranslating
          : isTranslating // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
abstract class _$StateCopyWith<$Res> implements $TweetStateCopyWith<$Res> {
  factory _$StateCopyWith(_State value, $Res Function(_State) then) =
      __$StateCopyWithImpl<$Res>;
  @override
  $Res call(
      {bool retweeted, bool favorited, bool translated, bool isTranslating});
}

/// @nodoc
class __$StateCopyWithImpl<$Res> extends _$TweetStateCopyWithImpl<$Res>
    implements _$StateCopyWith<$Res> {
  __$StateCopyWithImpl(_State _value, $Res Function(_State) _then)
      : super(_value, (v) => _then(v as _State));

  @override
  _State get _value => super._value as _State;

  @override
  $Res call({
    Object? retweeted = freezed,
    Object? favorited = freezed,
    Object? translated = freezed,
    Object? isTranslating = freezed,
  }) {
    return _then(_State(
      retweeted: retweeted == freezed
          ? _value.retweeted
          : retweeted // ignore: cast_nullable_to_non_nullable
              as bool,
      favorited: favorited == freezed
          ? _value.favorited
          : favorited // ignore: cast_nullable_to_non_nullable
              as bool,
      translated: translated == freezed
          ? _value.translated
          : translated // ignore: cast_nullable_to_non_nullable
              as bool,
      isTranslating: isTranslating == freezed
          ? _value.isTranslating
          : isTranslating // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_State implements _State {
  const _$_State(
      {required this.retweeted,
      required this.favorited,
      required this.translated,
      required this.isTranslating});

  @override
  final bool retweeted;
  @override
  final bool favorited;
  @override
  final bool translated;
  @override
  final bool isTranslating;

  @override
  String toString() {
    return 'TweetState(retweeted: $retweeted, favorited: $favorited, translated: $translated, isTranslating: $isTranslating)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _State &&
            (identical(other.retweeted, retweeted) ||
                other.retweeted == retweeted) &&
            (identical(other.favorited, favorited) ||
                other.favorited == favorited) &&
            (identical(other.translated, translated) ||
                other.translated == translated) &&
            (identical(other.isTranslating, isTranslating) ||
                other.isTranslating == isTranslating));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, retweeted, favorited, translated, isTranslating);

  @JsonKey(ignore: true)
  @override
  _$StateCopyWith<_State> get copyWith =>
      __$StateCopyWithImpl<_State>(this, _$identity);
}

abstract class _State implements TweetState {
  const factory _State(
      {required bool retweeted,
      required bool favorited,
      required bool translated,
      required bool isTranslating}) = _$_State;

  @override
  bool get retweeted;
  @override
  bool get favorited;
  @override
  bool get translated;
  @override
  bool get isTranslating;
  @override
  @JsonKey(ignore: true)
  _$StateCopyWith<_State> get copyWith => throw _privateConstructorUsedError;
}
