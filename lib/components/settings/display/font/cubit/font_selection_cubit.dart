import 'package:built_collection/built_collection.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harpy/harpy_widgets/theme/harpy_theme.dart';

part 'font_selection_cubit.freezed.dart';

class FontSelectionCubit extends Cubit<FontSelectionState> {
  FontSelectionCubit({
    required String initialPreview,
  }) : super(
          FontSelectionState(
            preview: initialPreview,
            fonts: BuiltList(),
          ),
        ) {
    _googleFonts =
        GoogleFonts.asMap().keys.whereNot(kAssetFonts.contains).toBuiltList();

    emit(state.copyWith(fonts: _googleFonts));
  }

  late final BuiltList<String> _googleFonts;

  void updateFilter(String filter) {
    if (filter.isEmpty) {
      emit(state.copyWith(fonts: _googleFonts));
    } else {
      emit(
        state.copyWith(
          fonts: _googleFonts
              .where(
                (font) => font.toLowerCase().contains(filter.toLowerCase()),
              )
              .toBuiltList(),
        ),
      );
    }
  }

  void selectPreview(String preview) {
    emit(state.copyWith(preview: preview));
  }
}

@freezed
class FontSelectionState with _$FontSelectionState {
  const factory FontSelectionState({
    required String preview,
    required BuiltList<String> fonts,
  }) = _State;
}
