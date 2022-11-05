import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rby/rby.dart';

const MethodChannel _channel = MethodChannel(
  'com.robertodoering.harpy',
);

final hasUnapprovedDomainsProvider = FutureProvider.autoDispose(
  name: 'hasUnapprovedDomainsProvider',
  (ref) => _channel
      .invokeMethod<bool>('hasUnapprovedDomains')
      .handleError(logErrorHandler)
      .then((value) => value ?? false),
);

Future<void> showOpenByDefault() {
  return _channel
      .invokeMethod('showOpenByDefault')
      .handleError(logErrorHandler);
}

/// Whether the user has not approved every deeplink that harpy can handle
/// (twitter urls).
///
/// On Android 12+ the urls will always be unapproved by dewfault since you need
/// to verify ownership of the url.
Future<bool> hasUnapprovedDomains() {
  return _channel
      .invokeMethod<bool>('hasUnapprovedDomains')
      .handleError(logErrorHandler)
      .then((value) => value ?? false);
}
