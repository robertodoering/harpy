import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:harpy/core/utils/string_utils.dart';
import 'package:harpy/models/application_model.dart';
import 'package:http/http.dart';
import 'package:logging/logging.dart';
import 'package:oauth1/oauth1.dart' as oauth1;
import 'package:path_provider/path_provider.dart';

/// Provides methods for network calls.
///
/// Every call times out after 20 seconds and throws a [TimeoutException] on
/// timeout.
///
/// If a response does not have a status code of 2xx the response is thrown
/// as an exception instead of being returned.
class TwitterClient {
  static final Logger _log = Logger("TwitterClient");

  static const Duration _timeout = Duration(seconds: 20);

  ApplicationModel applicationModel;

  oauth1.Platform get _platform {
    return oauth1.Platform(
      'https://api.twitter.com/oauth/request_token',
      'https://api.twitter.com/oauth/authorize',
      'https://api.twitter.com/oauth/access_token',
      oauth1.SignatureMethods.hmacSha1,
    );
  }

  oauth1.ClientCredentials get _clientCredentials {
    assert(applicationModel != null);
    assert(applicationModel.twitterLogin != null);

    return oauth1.ClientCredentials(
      applicationModel.twitterLogin.consumerKey,
      applicationModel.twitterLogin.consumerSecret,
    );
  }

  oauth1.Client get _client {
    assert(applicationModel != null);
    assert(applicationModel.twitterSession != null);

    return oauth1.Client(
      _platform.signatureMethod,
      _clientCredentials,
      oauth1.Credentials(
        applicationModel.twitterSession.token,
        applicationModel.twitterSession.secret,
      ),
    );
  }

  /// Saves the response on the device as a file for debugging.
  Future<void> _saveResponse(Response response) async {
    _log.info("saving response");
    final dir = await getApplicationDocumentsDirectory();

    final String url =
        response.request.url.toString().split("/").last.split("?").first;
    final String time = DateTime.now().toIso8601String();

    final String path = "${dir.path}/responses/${time}_$url";
    File(path)
      ..createSync(recursive: true)
      ..writeAsStringSync(response.body);
    _log.info("response saved in $path");
  }

  Future<Response> get(
    String url, {
    Map<String, String> headers,
    Map<String, String> params,
    Duration timeout,
  }) {
    _log
      ..fine("sending get request: $url")
      ..fine("headers: $headers")
      ..fine("params: $params");

    url = appendParamsToUrl(url, params);

    return _client
        .get(url, headers: headers)
        .timeout(timeout ?? _timeout)
        .then((response) {
//      _saveResponse(response);
      if (!response.statusCode.toString().startsWith("2")) {
        return Future.error(response);
      } else {
        return response;
      }
    });
  }

  Future<Response> post(
    String url, {
    Map<String, String> headers,
    Map<String, String> params,
    dynamic body,
    Encoding encoding,
    Duration timeout = _timeout,
  }) {
    _log
      ..fine("sending post request: $url")
      ..fine("headers: $headers")
      ..fine("params: $params")
      ..fine("body: $body");

    url = appendParamsToUrl(url, params);

    return _client
        .post(url, headers: headers, body: body, encoding: encoding)
        .timeout(_timeout)
        .then((response) {
//      _saveResponse(response);
      if (!response.statusCode.toString().startsWith("2")) {
        return Future.error(response);
      } else {
        return response;
      }
    });
  }

  Future<Response> multipartRequest(
    String url, {
    List<int> fileBytes,
    Map<String, String> headers,
    Map<String, String> params,
  }) async {
    _log
      ..fine("sending multipartRequest post request: $url")
      ..fine("headers: $headers")
      ..fine("params: $params")
      ..fine("fileBytes: ${fileBytes?.length}");

    url = appendParamsToUrl(url, params);

    final request = MultipartRequest("POST", Uri.parse(url));

    if (fileBytes != null) {
      request.files.add(MultipartFile.fromBytes("media", fileBytes));
    }
    if (headers != null) request.headers.addAll(headers);

    return Response.fromStream(
      await _client.send(request),
    ).then((response) {
      if (!response.statusCode.toString().startsWith("2")) {
        return Future.error(response);
      } else {
        return response;
      }
    });
  }
}
