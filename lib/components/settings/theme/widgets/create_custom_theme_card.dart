import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:rby/rby.dart';

class CreateCustomThemeCard extends StatelessWidget {
  const CreateCustomThemeCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: theme.spacing.symmetric(horizontal: true),
      child: RbyListCard(
        color: Colors.transparent,
        leading: const Icon(CupertinoIcons.add),
        title: const Text('create custom theme'),
        trailing: isFree ? const FlareIcon.shiningStar() : null,
        border: Border.all(color: theme.dividerColor),
        onTap: () => context.goNamed(CustomThemePage.name),
      ),
    );
  }
}
