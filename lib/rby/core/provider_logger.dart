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
    log
      ..info(_msg('added', provider))
      ..info('         $value');
  }

  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    log
      ..info(_msg('updated', provider))
      ..info('         $newValue');

    if (newValue is AsyncError) {
      log.warning('async error', newValue.error, newValue.stackTrace);
    }
  }

  @override
  void didDisposeProvider(
    ProviderBase provider,
    ProviderContainer containers,
  ) {
    log.info(_msg('disposed', provider));
  }

  String _msg(String type, ProviderBase provider) {
    final buffer = StringBuffer(type.padRight(9));

    if (provider.name != null) {
      buffer.write('"${provider.name}" ');
    }

    buffer.write('${provider.runtimeType}');

    return buffer.toString();
  }
}
