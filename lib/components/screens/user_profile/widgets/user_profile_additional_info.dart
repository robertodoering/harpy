import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UserProfileAdditionalInfo extends StatelessWidget {
  const UserProfileAdditionalInfo({
    required this.user,
  });

  final UserData user;

  static final _createdAtFormat = DateFormat('MMMM yyyy');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = context.watch<ConfigCubit>().state;

    final bloc = context.watch<UserRelationshipBloc>();
    final state = bloc.state;

    final children = [
      if (user.hasLocation)
        _InfoRow(
          icon: const Icon(CupertinoIcons.map_pin_ellipse),
          child: Text(user.location!),
        ),
      if (user.hasCreatedAt)
        _InfoRow(
          icon: const Icon(CupertinoIcons.calendar),
          child: Text('joined ${_createdAtFormat.format(user.createdAt!)}'),
        ),
      if (user.hasUrl)
        _InfoRow(
          icon: const Icon(CupertinoIcons.link),
          child: GestureDetector(
            onTap: () => defaultOnUrlTap(context, user.userUrl!),
            onLongPress: () => defaultOnUrlLongPress(context, user.userUrl!),
            child: Text(
              user.userUrl!.displayUrl,
              style: theme.textTheme.bodyText1!.copyWith(
                color: theme.colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      if (state.followedBy)
        const _InfoRow(
          icon: Icon(CupertinoIcons.reply),
          child: Text('follows you'),
        ),
    ];

    return Column(
      children: [
        for (final child in children) ...[
          child,
          if (child == children.last)
            smallVerticalSpacer
          else
            SizedBox(height: config.smallPaddingValue / 2),
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
      data: theme.iconTheme.copyWith(size: 16),
      child: DefaultTextStyle(
        style: theme.textTheme.bodyText1!,
        child: Row(
          children: [
            icon,
            horizontalSpacer,
            Expanded(
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
