import 'dart:convert';

import 'package:harpy/api/translate/data/translation.dart';
import 'package:harpy/api/translate/languages.dart';
import 'package:harpy/core/utils/string_utils.dart';
import 'package:http/http.dart';
import 'package:logging/logging.dart';

class TranslationService {
  static const String _url = "https://translate.google.com/translate_a/single";
  static final Logger _log = Logger("TranslationService");

  /// Translates the [text] and returns a [Translation] object or a
  /// [Future.error] if it failed.
  Future<Translation> translate({
    String text,
    String from = "auto",
    String to = "en",
  }) async {
    _log.fine("translating from $from to $to");

    // encode text
    text = Uri.encodeComponent(text);

    final params = <String, String>{
      "client": 'gtx',
      "sl": from,
      "tl": to,
      "dt": "t",
      "q": text,
      "ie": "UTF-8",
      "oe": "UTF-8",
    };

    final String requestUrl = appendParamsToUrl(_url, params);

    final Response response = await get(requestUrl);

    if (response.statusCode != 200) {
      return Future.error(response.statusCode);
    }

    try {
      // try to parse translation from response
      final List jsonList = jsonDecode(response.body);

      String original = "";
      String translated = "";

      for (List translationText in jsonList[0]) {
        original += translationText[1];
        translated += translationText[0];
      }

      return Translation(
        original, // original
        translated, // translated text
        jsonList.last[0][0], // language code
        languages[jsonList.last[0][0]], // language
      );
    } on Exception {
      return Future.error(response.statusCode);
    }
  }
}
