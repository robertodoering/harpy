import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

class CustomThemeSecondaryColor extends ConsumerWidget {
  const CustomThemeSecondaryColor({
    required this.notifier,
  });

  final CustomThemeNotifier notifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final harpyTheme = ref.watch(harpyThemeProvider);

    return CustomThemeColor(
      color: harpyTheme.colors.secondary,
      title: const Text('secondary'),
      subtitle: Text(
        colorValueToDisplayHex(
          harpyTheme.colors.secondary.value,
          displayOpacity: false,
        ),
      ),
      onColorChanged: notifier.changeSecondaryColor,
    );
  }
}
