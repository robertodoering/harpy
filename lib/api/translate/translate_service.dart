import 'dart:convert';

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
    required String? text,
    String from = 'auto',
    String to = 'en',
  }) async {
    _log.fine('translating from $from to $to');

    final params = <String, String?>{
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

  Future<http.Response> _validateResponse(http.Response response) async {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    } else {
      return Future<http.Response>.error(response);
    }
  }

  Translation _transformResponse(http.Response response) {
    try {
      // try to parse translation from response
      final List<dynamic> body = jsonDecode(response.body);

      final original = StringBuffer();
      final translated = StringBuffer();

      for (final List<dynamic> translationText in body[0]) {
        original.write(translationText[1]);
        translated.write(translationText[0]);
      }

      _log.fine('translated from:\n$original\nto:\n$translated');

      return Translation(
        original: original.toString(),
        text: translated.toString(),
        // ignore: avoid_dynamic_calls
        languageCode: body.last[0][0],
        // ignore: avoid_dynamic_calls
        language: translateLanguages[body.last[0][0]],
      );
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
