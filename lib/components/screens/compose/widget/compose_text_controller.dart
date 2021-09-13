import 'package:flutter/material.dart';
import 'package:harpy/core/core.dart';

/// A [TextEditingController] for the compose screen.
class ComposeTextController extends TextEditingController {
  ComposeTextController({
    String? text,
    this.textStyleMap = const <RegExp, TextStyle>{},
  }) : super(text: text) {
    addListener(_listener);
  }

  /// Maps text styles to matches for the [RegExp].
  final Map<RegExp, TextStyle> textStyleMap;

  /// Callbacks that are mapped to a [RegExp] that will fire the callback with
  /// the selected word whenever the selected word matches the [RegExp].
  ///
  /// If the word does not match the [RegExp], the callback is invoked with
  /// `null`.
  ///
  /// A word is selected whenever the cursor is at the start, end, or in the
  /// middle of a word separated by whitespaces.
  final Map<RegExp, ValueChanged<String?>> selectionRecognizers =
      <RegExp, ValueChanged<String?>>{};

  void replaceSelection(String replacement) {
    if (text.isNotEmpty &&
        selection.baseOffset >= 0 &&
        selection.baseOffset == selection.extentOffset) {
      var selectionStart = selection.baseOffset - 1;
      var selectionEnd = selection.baseOffset;

      while (selectionStart >= 0) {
        if (whitespaceRegex.hasMatch(text[selectionStart])) {
          break;
        }

        selectionStart--;
      }

      while (selectionEnd < text.length) {
        if (whitespaceRegex.hasMatch(text[selectionEnd])) {
          break;
        }

        selectionEnd++;
      }

      final textStart = text.substring(0, selectionStart + 1);
      final textEnd = text.substring(selectionEnd, text.length);

      value = TextEditingValue(
        text: '$textStart$replacement$textEnd',
        selection: TextSelection.collapsed(
          offset: selectionStart + 1 + replacement.length,
        ),
      );
    }
  }

  void insertString(String string) {
    if (selection.baseOffset < 0) {
      value = TextEditingValue(
        text: '$text$string',
        selection: TextSelection.collapsed(
          offset: selection.baseOffset + string.length,
        ),
      );
    } else if (selection.baseOffset == selection.extentOffset) {
      final textStart = text.substring(0, selection.baseOffset);
      final textEnd = text.substring(selection.baseOffset);

      value = TextEditingValue(
        text: '$textStart$string$textEnd',
        selection: TextSelection.collapsed(
          offset: selection.baseOffset + string.length,
        ),
      );
    }
  }

  /// A listener that will fire the [selectionRecognizers] if a selected word
  /// matches the regex.
  void _listener() {
    if (text.isEmpty) {
      // reset selection recognizers when text got deleted
      for (final recognizer in selectionRecognizers.values) {
        recognizer(null);
      }
    } else if (text.isNotEmpty &&
        selection.baseOffset >= 0 &&
        selection.baseOffset == selection.extentOffset) {
      final start =
          text.substring(0, selection.baseOffset).split(whitespaceRegex).last;

      final end =
          text.substring(selection.baseOffset).split(whitespaceRegex).first;

      final word = '$start$end'.trim();

      for (final entry in selectionRecognizers.entries) {
        if (entry.key.hasMatch(word)) {
          entry.value(word);
        } else {
          entry.value(null);
        }
      }
    }
  }

  @override
  TextSpan buildTextSpan({
    BuildContext? context,
    TextStyle? style,
    bool? withComposing,
  }) {
    final children = <TextSpan>[];

    text.splitMapJoin(
      RegExp(
        textStyleMap.keys.map((regExp) => regExp.pattern).join('|'),
        unicode: true,
        caseSensitive: false,
      ),
      onMatch: (match) {
        final regExp = textStyleMap.entries
            .singleWhere(
              (element) => element.key.allMatches(match[0]!).isNotEmpty,
            )
            .key;

        children.add(
          TextSpan(
            text: match[0],
            style: textStyleMap[regExp],
          ),
        );

        return match[0]!;
      },
      onNonMatch: (nonMatch) {
        children.add(TextSpan(text: nonMatch, style: style));
        return nonMatch;
      },
    );

    return TextSpan(style: style, children: children);
  }
}
