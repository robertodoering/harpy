import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/rby/rby.dart';

class ProviderLogger extends ProviderObserver with LoggerMixin {
  const ProviderLogger();

  @override
  void didAddProvider(
    ProviderBase provider,
    Object? value,
    ProviderContainer container,
  ) {
    if (provider.name != null) {
      log
        ..info(_msg('added', provider))
        ..info('         ${value.runtimeType}');
    }
  }

  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    if (provider.name != null) {
      log
        ..info(_msg('updated', provider))
        ..info('         ${newValue.runtimeType}');
    }

    if (newValue is AsyncError) {
      log.warning('async error', newValue.error, newValue.stackTrace);
    }
  }

  @override
  void didDisposeProvider(
    ProviderBase provider,
    ProviderContainer container,
  ) {
    if (provider.name != null) {
      log.info(_msg('disposed', provider));
    }
  }

  String _msg(String type, ProviderBase provider) {
    final buffer = StringBuffer(type.padRight(9))
      ..write('"${provider.name}" ')
      ..write('${provider.runtimeType}');

    return buffer.toString();
  }
}
