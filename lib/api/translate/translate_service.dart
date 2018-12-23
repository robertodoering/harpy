import 'dart:convert';

import 'package:harpy/api/translate/data/translation.dart';
import 'package:harpy/api/translate/languages.dart';
import 'package:harpy/core/utils/string_utils.dart';
import 'package:http/http.dart';

/// Translates the [text] and returns a [Translation] object or a [Future.error]
/// if it failed.
Future<Translation> translate({
  String text,
  String from = "auto",
  String to = "en",
}) async {
  String url = "https://translate.google.com/translate_a/single";

  text = Uri.encodeComponent(text);

  Map<String, String> params = {
    "client": 'gtx',
    "sl": from,
    "tl": to,
    "dt": "t",
    "q": text,
    "ie": "UTF-8",
    "oe": "UTF-8",
  };

  url = appendParamsToUrl(url, params);

  Response response = await get(url);

  if (response.statusCode != 200) {
    return Future.error(response.statusCode);
  }

  try {
    // parse translation from response
    List jsonList = jsonDecode(response.body);

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
