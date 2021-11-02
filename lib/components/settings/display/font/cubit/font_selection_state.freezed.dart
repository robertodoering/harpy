// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'font_selection_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$FontSelectionStateTearOff {
  const _$FontSelectionStateTearOff();

  _FontSelectionState call(
      {required String preview, required BuiltList<String> fonts}) {
    return _FontSelectionState(
      preview: preview,
      fonts: fonts,
    );
  }
}

/// @nodoc
const $FontSelectionState = _$FontSelectionStateTearOff();

/// @nodoc
mixin _$FontSelectionState {
  String get preview => throw _privateConstructorUsedError;
  BuiltList<String> get fonts => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $FontSelectionStateCopyWith<FontSelectionState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FontSelectionStateCopyWith<$Res> {
  factory $FontSelectionStateCopyWith(
          FontSelectionState value, $Res Function(FontSelectionState) then) =
      _$FontSelectionStateCopyWithImpl<$Res>;
  $Res call({String preview, BuiltList<String> fonts});
}

/// @nodoc
class _$FontSelectionStateCopyWithImpl<$Res>
    implements $FontSelectionStateCopyWith<$Res> {
  _$FontSelectionStateCopyWithImpl(this._value, this._then);

  final FontSelectionState _value;
  // ignore: unused_field
  final $Res Function(FontSelectionState) _then;

  @override
  $Res call({
    Object? preview = freezed,
    Object? fonts = freezed,
  }) {
    return _then(_value.copyWith(
      preview: preview == freezed
          ? _value.preview
          : preview // ignore: cast_nullable_to_non_nullable
              as String,
      fonts: fonts == freezed
          ? _value.fonts
          : fonts // ignore: cast_nullable_to_non_nullable
              as BuiltList<String>,
    ));
  }
}

/// @nodoc
abstract class _$FontSelectionStateCopyWith<$Res>
    implements $FontSelectionStateCopyWith<$Res> {
  factory _$FontSelectionStateCopyWith(
          _FontSelectionState value, $Res Function(_FontSelectionState) then) =
      __$FontSelectionStateCopyWithImpl<$Res>;
  @override
  $Res call({String preview, BuiltList<String> fonts});
}

/// @nodoc
class __$FontSelectionStateCopyWithImpl<$Res>
    extends _$FontSelectionStateCopyWithImpl<$Res>
    implements _$FontSelectionStateCopyWith<$Res> {
  __$FontSelectionStateCopyWithImpl(
      _FontSelectionState _value, $Res Function(_FontSelectionState) _then)
      : super(_value, (v) => _then(v as _FontSelectionState));

  @override
  _FontSelectionState get _value => super._value as _FontSelectionState;

  @override
  $Res call({
    Object? preview = freezed,
    Object? fonts = freezed,
  }) {
    return _then(_FontSelectionState(
      preview: preview == freezed
          ? _value.preview
          : preview // ignore: cast_nullable_to_non_nullable
              as String,
      fonts: fonts == freezed
          ? _value.fonts
          : fonts // ignore: cast_nullable_to_non_nullable
              as BuiltList<String>,
    ));
  }
}

/// @nodoc

class _$_FontSelectionState implements _FontSelectionState {
  const _$_FontSelectionState({required this.preview, required this.fonts});

  @override
  final String preview;
  @override
  final BuiltList<String> fonts;

  @override
  String toString() {
    return 'FontSelectionState(preview: $preview, fonts: $fonts)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FontSelectionState &&
            (identical(other.preview, preview) || other.preview == preview) &&
            (identical(other.fonts, fonts) || other.fonts == fonts));
  }

  @override
  int get hashCode => Object.hash(runtimeType, preview, fonts);

  @JsonKey(ignore: true)
  @override
  _$FontSelectionStateCopyWith<_FontSelectionState> get copyWith =>
      __$FontSelectionStateCopyWithImpl<_FontSelectionState>(this, _$identity);
}

abstract class _FontSelectionState implements FontSelectionState {
  const factory _FontSelectionState(
      {required String preview,
      required BuiltList<String> fonts}) = _$_FontSelectionState;

  @override
  String get preview;
  @override
  BuiltList<String> get fonts;
  @override
  @JsonKey(ignore: true)
  _$FontSelectionStateCopyWith<_FontSelectionState> get copyWith =>
      throw _privateConstructorUsedError;
}
