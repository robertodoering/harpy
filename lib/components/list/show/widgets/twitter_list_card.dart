import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';

class TwitterListCard extends StatelessWidget {
  const TwitterListCard({
    required Key key,
    required this.list,
    required this.onSelected,
    this.onLongPress,
  }) : super(key: key);

  final TwitterListData list;
  final VoidCallback onSelected;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: theme.shape.borderRadius,
      onLongPress: onLongPress,
      onTap: onSelected,
      child: Card(
        child: Padding(
          padding: theme.spacing.edgeInsets,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ListCardTitle(list: list),
              if (list.description.isNotEmpty) _ListDescription(list: list),
              if (list.user != null) ...[
                VerticalSpacer.small,
                _ListUser(list: list),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ListCardTitle extends StatelessWidget {
  const _ListCardTitle({
    required this.list,
  });

  final TwitterListData list;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Flexible(
          child: Text(
            list.name,
            style: theme.textTheme.titleSmall,
            softWrap: false,
            overflow: TextOverflow.fade,
          ),
        ),
        if (list.isPrivate) ...[
          SizedBox(width: theme.spacing.small / 2),
          const Icon(CupertinoIcons.padlock),
        ],
      ],
    );
  }
}

class _ListDescription extends StatelessWidget {
  const _ListDescription({
    required this.list,
  });

  final TwitterListData list;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      list.description,
      style: theme.textTheme.bodyLarge,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _ListUser extends StatelessWidget {
  const _ListUser({
    required this.list,
  });

  final TwitterListData list;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        if (list.user!.profileImage?.normal != null) ...[
          HarpyCircleAvatar(
            // use the normal sized profile image instead of the bigger one for
            // the small circle avatar
            imageUrl: list.user!.profileImage!.normal!.toString(),
            radius: 8,
          ),
          HorizontalSpacer.small,
        ],
        Flexible(
          child: Text(
            list.user!.name,
            style: theme.textTheme.bodyLarge,
            softWrap: false,
            overflow: TextOverflow.fade,
          ),
        ),
        HorizontalSpacer.small,
        Text(
          '@${list.user!.handle}',
          textDirection: TextDirection.ltr,
          style: theme.textTheme.bodyLarge,
          softWrap: false,
          overflow: TextOverflow.fade,
        ),
      ],
    );
  }
}
