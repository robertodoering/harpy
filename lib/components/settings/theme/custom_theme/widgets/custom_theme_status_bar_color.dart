import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

class CustomThemeStatusBarColor extends ConsumerWidget {
  const CustomThemeStatusBarColor({
    required this.notifier,
  });

  final CustomThemeNotifier notifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final harpyTheme = ref.watch(harpyThemeProvider);

    return CustomThemeColor(
      color: harpyTheme.colors.statusBarColor,
      enableAlpha: true,
      title: const Text('status bar'),
      subtitle: Text(
        colorValueToDisplayHex(harpyTheme.colors.statusBarColor.value),
      ),
      onColorChanged: notifier.changeStatusBarColor,
    );
  }
}
