import 'package:built_collection/built_collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'font_selection_state.freezed.dart';

@freezed
class FontSelectionState with _$FontSelectionState {
  const factory FontSelectionState({
    required String preview,
    required BuiltList<String> fonts,
  }) = _FontSelectionState;
}
