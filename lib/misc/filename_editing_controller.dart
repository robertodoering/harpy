import 'package:flutter/material.dart';

/// Prevents adding characters that are invalid in a file name.
///
/// What characters are invalid depend on the file system. Invalid characters
/// that we check for are `|\\?*<":>+[]/\'`.
class FilenameEditingController extends TextEditingController {
  FilenameEditingController({String? text}) : super(text: text);

  /// A single capturing group with invalid filename characters.
  ///
  /// We use a multiline string since both ' and " are used in the group.
  final _invalidFilenameRegex = RegExp(r'''[|\\?*<":>+\[\]/']''');

  @override
  set value(TextEditingValue newValue) {
    if (!newValue.text.contains(_invalidFilenameRegex)) {
      super.value = newValue;
    }
  }
}
