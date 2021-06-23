import 'dart:io';

/// This fixes regex that has invalid unicode ranges.
///
/// The regex found in the twitter-text library
/// (https://github.com/twitter/twitter-text) contains regex with invalid
/// unicode ranges (from high to low)
/// In dart, character ranges always have to start with the lowest character.
///
/// Example:
/// Input:  `\ud83c\udffb\ud83c\udffd-\ud83c\udfff`
/// Output: `\ud83c\udffb\ud83c\ud83c-\udffd\udfff`
void main(List<String> arguments) {
  final elements = arguments[0].split(r'\u');

  for (var i = 0; i < elements.length; i++) {
    final element = elements[i];

    if (element.endsWith('-')) {
      // start of range
      final nextElement = elements[i + 1];

      final start = int.tryParse(element.replaceAll('-', ''), radix: 16);
      final end = int.tryParse(nextElement, radix: 16);

      if (start != null && end != null && start > end) {
        elements[i] = '$nextElement-';
        elements[++i] = element.replaceAll('-', '');
      }
    }
  }

  File('regex.txt').writeAsString(elements.join(r'\u'));
}
