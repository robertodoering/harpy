import 'package:built_collection/built_collection.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harpy/core/core.dart';

final fontSelectionProvider =
    StateNotifierProvider.autoDispose<FontSelectionNotifier, BuiltList<String>>(
  (ref) => FontSelectionNotifier(
    googleFonts:
        GoogleFonts.asMap().keys.whereNot(kAssetFonts.contains).toBuiltList(),
  ),
  name: 'FontSelectionProvider',
);

class FontSelectionNotifier extends StateNotifier<BuiltList<String>> {
  FontSelectionNotifier({
    required BuiltList<String> googleFonts,
  })  : _googleFonts = googleFonts,
        super(googleFonts);

  final BuiltList<String> _googleFonts;

  void updateFilter(String filter) {
    if (filter.isEmpty) {
      state = _googleFonts;
    } else {
      state = _googleFonts.rebuild(
        (builder) => builder.where(
          (font) => font.toLowerCase().contains(filter.toLowerCase()),
        ),
      );
    }
  }
}
