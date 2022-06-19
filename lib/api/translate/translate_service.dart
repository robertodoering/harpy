import 'dart:convert';

import 'package:harpy/api/api.dart';
import 'package:http/http.dart';

const _timeout = Duration(seconds: 10);

class TranslateService {
  Future<Translation> translate({
    required String text,
    required String to,
    String from = 'auto',
  }) async {
    final params = {
      'client': 'gtx',
      'sl': from,
      'tl': to,
      'dt': 't',
      'q': text,
      'ie': 'UTF-8',
      'oe': 'UTF-8',
    };

    return get(Uri.https('translate.google.com', '/translate_a/single', params))
        .timeout(_timeout)
        .then(_validateResponse)
        .then(_transformResponse);
  }

  Future<Response> _validateResponse(Response response) async {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    } else {
      return Future.error(response);
    }
  }

  Translation _transformResponse(Response response) {
    final body = jsonDecode(response.body) as List<dynamic>;

    final original = StringBuffer();
    final translated = StringBuffer();

    for (final translationText in body[0] as List<dynamic>) {
      original.write((translationText as List<dynamic>)[1]);
      translated.write(translationText[0]);
    }

    return Translation(
      original: original.toString(),
      text: translated.toString(),
      // ignore: avoid_dynamic_calls
      languageCode: body.last[0][0] as String?,
      // ignore: avoid_dynamic_calls
      language: kTranslateLanguages[body.last[0][0]],
    );
  }
}
