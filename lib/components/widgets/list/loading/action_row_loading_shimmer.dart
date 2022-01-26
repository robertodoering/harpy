import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:provider/provider.dart';

class ActionRowLoading extends StatelessWidget {
  const ActionRowLoading({
    this.beginCount = 1,
    this.endCount = 1,
  });

  final int beginCount;
  final int endCount;

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigCubit>().state;

    return Padding(
      padding: config.edgeInsetsSymmetric(horizontal: true),
      child: Row(
        children: [
          for (var i = 0; i < beginCount; i++) ...[
            const _ActionButtonPlaceholder(),
            if (i != beginCount - 1) horizontalSpacer,
          ],
          const Spacer(),
          for (var i = 0; i < endCount; i++) ...[
            const _ActionButtonPlaceholder(),
            if (i != endCount - 1) horizontalSpacer,
          ],
        ],
      ),
    );
  }
}

class _ActionButtonPlaceholder extends StatelessWidget {
  const _ActionButtonPlaceholder();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = context.watch<ConfigCubit>().state;

    return PlaceholderBox(
      width: theme.iconTheme.size! + config.paddingValue * 2,
      height: theme.iconTheme.size! + config.paddingValue * 2,
    );
  }
}
