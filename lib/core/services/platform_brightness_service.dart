import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final platformBrightnessProvider = StateProvider(
  (ref) {
    assert(WidgetsBinding.instance != null);

    final observer = _PlatformBrightnessObserver(
      onBrightnessChanged: (brightness) {
        ref.read(platformBrightnessProvider.notifier).state = brightness;
      },
    );

    WidgetsBinding.instance?.addObserver(observer);
    ref.onDispose(() => WidgetsBinding.instance?.removeObserver(observer));

    return WidgetsBinding.instance?.platformDispatcher.platformBrightness ??
        Brightness.light;
  },
  name: 'PlatformBrightnessProvider',
);

class _PlatformBrightnessObserver with WidgetsBindingObserver {
  const _PlatformBrightnessObserver({
    required this.onBrightnessChanged,
  });

  final ValueChanged<Brightness> onBrightnessChanged;

  @override
  void didChangePlatformBrightness() {
    onBrightnessChanged(
      WidgetsBinding.instance?.platformDispatcher.platformBrightness ??
          Brightness.light,
    );
  }
}
