import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/rby/rby.dart';

const MethodChannel _channel = MethodChannel(
  'com.robertodoering.harpy',
);

final hasUnapprovedDomainsProvider = FutureProvider.autoDispose(
  name: 'hasUnapprovedDomainsProvider',
  cacheTime: const Duration(minutes: 1),
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

Future<bool> hasUnapprovedDomains() {
  return _channel
      .invokeMethod<bool>('hasUnapprovedDomains')
      .handleError(logErrorHandler)
      .then((value) => value ?? false);
}
