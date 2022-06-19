import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

class CustomThemePrimaryColor extends ConsumerWidget {
  const CustomThemePrimaryColor({
    required this.notifier,
  });

  final CustomThemeNotifier notifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final harpyTheme = ref.watch(harpyThemeProvider);

    return CustomThemeColor(
      color: harpyTheme.colors.primary,
      title: const Text('primary'),
      subtitle: Text(
        colorValueToDisplayHex(
          harpyTheme.colors.primary.value,
          displayOpacity: false,
        ),
      ),
      onColorChanged: notifier.changePrimaryColor,
    );
  }
}
