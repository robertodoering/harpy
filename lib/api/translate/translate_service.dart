import 'dart:convert';

import 'package:harpy/api/translate/languages.dart';
import 'package:harpy/core/utils/string_utils.dart';
import 'package:http/http.dart';

class Translation {
  final String original;
  final String text;
  final String languageCode;
  final String language;

  bool get unchanged => original == text;

  const Translation({
    this.original,
    this.text,
    this.languageCode,
    this.language,
  });

  @override
  String toString() {
    return 'Translation{original: $original, text: $text, languageCode: $languageCode, language: $language}';
  }
}

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

  print("url: $url");

  Response response = await get(url);

  print(response.statusCode);
  print(response.body);

  if (response.statusCode != 200) {
    return Future.error(response.statusCode);
  }

//  List jsonList = jsonDecode(
//      '[[["One solution is necessary for many languages","多くの言語では1つの解決策が必要",null,null,3]],null,"ja",null,null,null,1,null,[["ja"],null,[1],["ja"]]]');

//  print(jsonList[0][0][0]); // translated text
//  print(jsonList[0][0][1]); // original text
//  print(jsonList.last[0][0]); // language

  try {
    // parse translation from response
    List jsonList = jsonDecode(response.body);

    return Translation(
      original: jsonList[0][0][0],
      text: jsonList[0][0][1],
      languageCode: jsonList.last[0][0],
      language: languages[jsonList.last[0][0]],
    );
  } on Exception {
    return Future.error(response.statusCode);
  }
}
