import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:harpy/api/api.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

class TranslationService {
  static final Logger _log = Logger('TranslationService');

  static const Duration _timeout = Duration(seconds: 10);

  /// Translates the [text] to the [to] language.
  ///
  /// Throws an error if the response is not valid or if the [Translation]
  /// object was unable to be parsed from the response.
  Future<Translation> translate({
    @required String text,
    String from = 'auto',
    String to = 'en',
  }) async {
    _log.fine('translating from $from to $to');

    final Map<String, String> params = <String, String>{
      'client': 'gtx',
      'sl': from,
      'tl': to,
      'dt': 't',
      'q': text,
      'ie': 'UTF-8',
      'oe': 'UTF-8',
    };

    return http
        .get(Uri.https('translate.google.com', '/translate_a/single', params))
        .timeout(_timeout)
        .then(_validateResponse)
        .then(_transformResponse);
  }

  http.Response _validateResponse(http.Response response) {
    return response.statusCode >= 200 && response.statusCode < 300
        ? response
        : Future<dynamic>.error(response);
  }

  Translation _transformResponse(http.Response response) {
    try {
      // try to parse translation from response
      final List<dynamic> body = jsonDecode(response.body);

      String original = '';
      String translated = '';

      for (List<dynamic> translationText in body[0]) {
        original += translationText[1];
        translated += translationText[0];
      }

      _log.fine('translated from:\n$original\nto:\n$translated');

      return Translation()
        ..original = original
        ..text = translated
        ..languageCode = body.last[0][0]
        ..language = translateLanguages[body.last[0][0]];
    } catch (e, st) {
      _log.severe(
        'error while trying to parse translate response: ${response.body}',
        e,
        st,
      );

      rethrow;
    }
  }
}
