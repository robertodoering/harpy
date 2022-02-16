import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

class CreateCustomThemeCard extends ConsumerWidget {
  const CreateCustomThemeCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final display = ref.watch(displayPreferencesProvider);
    final router = ref.watch(routerProvider);

    return Padding(
      padding: display.edgeInsetsSymmetric(horizontal: true),
      child: HarpyListCard(
        color: Colors.transparent,
        leading: const Icon(CupertinoIcons.add),
        title: const Text('create custom theme'),
        trailing: isFree ? const FlareIcon.shiningStar() : null,
        border: Border.all(color: theme.dividerColor),
        onTap: () => router.goNamed(CustomThemePage.name),
      ),
    );
  }
}
