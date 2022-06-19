import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

class TwitterListCard extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(displayPreferencesProvider);
    final harpyTheme = ref.watch(harpyThemeProvider);

    return InkWell(
      borderRadius: harpyTheme.borderRadius,
      onLongPress: onLongPress,
      onTap: onSelected,
      child: Card(
        child: Padding(
          padding: display.edgeInsets,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ListCardTitle(list: list),
              if (list.description.isNotEmpty) _ListDescription(list: list),
              if (list.user != null) ...[
                smallVerticalSpacer,
                _ListUser(list: list),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ListCardTitle extends ConsumerWidget {
  const _ListCardTitle({
    required this.list,
  });

  final TwitterListData list;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final display = ref.watch(displayPreferencesProvider);

    return Row(
      children: [
        Flexible(
          child: Text(
            list.name,
            style: theme.textTheme.subtitle2,
            softWrap: false,
            overflow: TextOverflow.fade,
          ),
        ),
        if (list.isPrivate) ...[
          SizedBox(width: display.smallPaddingValue / 2),
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
      style: theme.textTheme.bodyText1,
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
        HarpyCircleAvatar(
          // use the normal sized profile image instead of the bigger one for
          // the small circle avatar
          imageUrl: list.user!.profileImageUrl,
          radius: 8,
        ),
        smallHorizontalSpacer,
        Flexible(
          child: Text(
            list.user!.name,
            style: theme.textTheme.bodyText1,
            softWrap: false,
            overflow: TextOverflow.fade,
          ),
        ),
        smallHorizontalSpacer,
        Text(
          '@${list.user!.handle}',
          textDirection: TextDirection.ltr,
          style: theme.textTheme.bodyText1,
          softWrap: false,
          overflow: TextOverflow.fade,
        ),
      ],
    );
  }
}
