import 'dart:convert';

import 'package:harpy/api/dispatcher.dart';
import 'package:harpy/api/request_data.dart';
import 'package:harpy/core/app_configuration.dart';
import 'package:random_string/random_string.dart';

class TwitterAuthDispatcher extends Dispatcher {
  @override
  send(RequestData requestData) {
    print("Dispatch Twitter Request");
    requestData.headers
        .putIfAbsent("Authorization", () => _getTwitterAuthHeader(requestData));
  }

  String _getTwitterAuthHeader(RequestData requestData) {
    String header = "";

    header += 'oauth_consumer_key="' +
        AppConfiguration().applicationConfig.consumerKey +
        '",';
    header += 'oauth_nonce="' + _getRandomString() + '",';
    header += 'oauth_signature="' + _getRequestSignature(requestData) + '",';
    header += 'oauth_signature_method="HMAC-SHA1",';
    header += 'oauth_timestamp="' + _getCurrentTimestamp() + '",';
    header += 'oauth_token="' + AppConfiguration().twitterSession.token + '",';
    header += 'oauth_version="1.0"';

    return header;
  }

  String _getRandomString() {
    List<int> bytes = [];
    String rdmString = randomAlphaNumeric(32);

    for (int i = 0; i < rdmString.length; i++) {
      bytes.add(rdmString.codeUnitAt(i));
    }

    return Base64Codec.urlSafe().encode(bytes);
  }

  String _getRequestSignature(RequestData requestData) {
    // TODO implement
    return "";
  }

  String _getCurrentTimestamp() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
