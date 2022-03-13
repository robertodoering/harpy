import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

class UserAdditionalInfo extends ConsumerWidget {
  const UserAdditionalInfo({
    required this.user,
  });

  final UserData user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final display = ref.watch(displayPreferencesProvider);

    final l10n = Localizations.of<MaterialLocalizations>(
      context,
      MaterialLocalizations,
    )!;

    final children = [
      if (user.hasLocation)
        _InfoRow(
          icon: const Icon(CupertinoIcons.map_pin_ellipse),
          child: Text(user.location!),
        ),
      if (user.hasCreatedAt)
        _InfoRow(
          icon: const Icon(CupertinoIcons.calendar),
          child: Text(
            'joined ${l10n.formatMonthYear(user.createdAt!.toLocal())}',
          ),
        ),
      if (user.hasUrl)
        _InfoRow(
          icon: const Icon(CupertinoIcons.link),
          child: GestureDetector(
            onTap: () => defaultOnUrlTap(context, ref.read, user.userUrl!),
            onLongPress: () => defaultOnUrlLongPress(
              context,
              ref.read,
              user.userUrl!,
            ),
            child: Text(
              user.userUrl!.displayUrl,
              style: theme.textTheme.bodyText1!.copyWith(
                color: theme.colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      // if (state.followedBy)
      _InfoRow(
        icon: Icon(Icons.reply_rounded, color: theme.colorScheme.primary),
        child: Text(
          'follows you',
          style: TextStyle(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ];

    return Column(
      children: [
        for (final child in children) ...[
          child,
          if (child != children.last)
            SizedBox(height: display.smallPaddingValue / 2),
        ],
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.child,
  });

  final Widget icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IconTheme(
      data: theme.iconTheme.copyWith(size: theme.iconTheme.size! - 4),
      child: DefaultTextStyle(
        style: theme.textTheme.bodyText1!,
        child: Row(
          children: [
            icon,
            horizontalSpacer,
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
