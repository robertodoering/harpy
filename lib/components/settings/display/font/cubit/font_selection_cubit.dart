import 'package:built_collection/built_collection.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harpy/harpy_widgets/theme/harpy_theme.dart';

class FontSelectionCubit extends Cubit<BuiltList<String>> {
  FontSelectionCubit() : super(BuiltList()) {
    _googleFonts =
        GoogleFonts.asMap().keys.whereNot(kAssetFonts.contains).toBuiltList();

    emit(_googleFonts);
  }
  late final BuiltList<String> _googleFonts;

  void updateFilter(String filter) {
    if (filter.isEmpty) {
      emit(_googleFonts);
    } else {
      emit(
        _googleFonts
            .where((font) => font.toLowerCase().contains(filter.toLowerCase()))
            .toBuiltList(),
      );
    }
  }
}
