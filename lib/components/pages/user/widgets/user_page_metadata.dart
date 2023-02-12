import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/twitter/data/entities_data.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';

class UserPageMetadata extends StatelessWidget {
  const UserPageMetadata({
    required this.data,
  });

  final UserPageData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final l10n = Localizations.of<MaterialLocalizations>(
      context,
      MaterialLocalizations,
    )!;

    final children = [
      if (data.user.location != null)
        _Entry(
          icon: const Icon(CupertinoIcons.map_pin_ellipse),
          child: Text(data.user.location!),
        ),
      if (data.user.createdAt != null)
        _Entry(
          icon: const Icon(CupertinoIcons.calendar),
          child: Text(
            'joined ${l10n.formatMonthYear(data.user.createdAt!.toLocal())}',
          ),
        ),
      if (data.user.url != null) _UrlEntry(url: data.user.url!),
      if (data.relationship?.followedBy ?? false)
        _Entry(
          icon: Icon(Icons.reply_rounded, color: theme.colorScheme.primary),
          child: Text(
            'follows you',
            style: TextStyle(color: theme.colorScheme.primary),
          ),
        ),
    ];

    if (children.isEmpty) return const SizedBox();

    return Padding(
      padding: EdgeInsetsDirectional.only(top: theme.spacing.small),
      child: Wrap(
        spacing: theme.spacing.base,
        runSpacing: theme.spacing.small / 2,
        children: children,
      ),
    );
  }
}

class _UrlEntry extends ConsumerWidget {
  const _UrlEntry({
    required this.url,
  });

  final UrlData url;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return _Entry(
      icon: const Icon(CupertinoIcons.link),
      child: GestureDetector(
        onTap: () => defaultOnUrlTap(ref, url),
        onLongPress: () => defaultOnUrlLongPress(ref, url),
        child: Text(
          url.displayUrl,
          style: theme.textTheme.bodyLarge!.copyWith(
            color: theme.colorScheme.secondary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _Entry extends StatelessWidget {
  const _Entry({
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
        style: theme.textTheme.bodyLarge!,
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
