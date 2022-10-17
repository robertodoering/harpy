import 'package:built_collection/built_collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';

class UserAdditionalInfo extends ConsumerWidget {
  const UserAdditionalInfo({required this.user, required this.connections});

  final UserData user;
  final BuiltSet<UserConnection>? connections;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

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
            onTap: () => defaultOnUrlTap(ref, user.userUrl!),
            onLongPress: () => defaultOnUrlLongPress(ref, user.userUrl!),
            child: Text(
              user.userUrl!.displayUrl,
              style: theme.textTheme.bodyText1!.copyWith(
                color: theme.colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      if (connections?.contains(UserConnection.followedBy) ?? false)
        _InfoRow(
          icon: Icon(Icons.reply_rounded, color: theme.colorScheme.primary),
          child: Text(
            'follows you',
            style: TextStyle(color: theme.colorScheme.primary),
          ),
        ),
    ];

    return Column(
      children: [
        for (final child in children) ...[
          child,
          if (child != children.last) SizedBox(height: theme.spacing.small / 2),
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
            HorizontalSpacer.normal,
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
