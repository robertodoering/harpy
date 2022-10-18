import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

class ProviderLogger extends ProviderObserver {
  final Logger _log = Logger('');

  @override
  void didAddProvider(
    ProviderBase<dynamic> provider,
    Object? value,
    ProviderContainer container,
  ) {
    if (provider.name != null) {
      _log
        ..info(_msg('added', provider))
        ..info('         ${value.runtimeType}');
    }
  }

  @override
  void didUpdateProvider(
    ProviderBase<dynamic> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    if (provider.name == null) return;

    _log.info(_msg('updated', provider));

    if (newValue is AsyncData) {
      _log.info('         ${newValue.value}');
    } else {
      _log.info('         ${newValue.runtimeType}');
    }

    if (newValue is AsyncError) {
      _log.warning('async error', newValue.error, newValue.stackTrace);
    }
  }

  @override
  void didDisposeProvider(
    ProviderBase<dynamic> provider,
    ProviderContainer container,
  ) {
    if (provider.name != null) {
      _log.info(_msg('disposed', provider));
    }
  }

  String _msg(String type, ProviderBase<dynamic> provider) {
    final buffer = StringBuffer(type.padRight(9))
      ..write('"${provider.name}" ')
      ..write('${provider.runtimeType}');

    return buffer.toString();
  }
}
