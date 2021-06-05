import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

/// Builds a card that represents a twitter list.
class TwitterListCard extends StatelessWidget {
  const TwitterListCard(
    this.list, {
    required this.onSelected,
    required Key key,
    this.onLongPress,
  }) : super(key: key);

  final TwitterListData list;
  final VoidCallback onSelected;
  final VoidCallback? onLongPress;

  Widget _buildTitle(ThemeData theme) {
    return Row(
      children: <Widget>[
        Flexible(
          child: Text(
            list.name,
            style: theme.textTheme.subtitle2,
            softWrap: false,
            overflow: TextOverflow.fade,
          ),
        ),
        if (list.isPrivate) ...<Widget>[
          SizedBox(width: defaultSmallPaddingValue / 2),
          const Icon(CupertinoIcons.padlock),
        ],
      ],
    );
  }

  Widget _buildDescription(ThemeData theme) {
    return Text(
      list.description!,
      style: theme.textTheme.bodyText1,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildUserRow(ThemeData theme) {
    return Row(
      children: <Widget>[
        HarpyCircleAvatar(
          // use the normal sized profile image instead of the bigger one for
          // the small circle avatar
          imageUrl: list.user!.profileImageUrl,
          radius: 8,
        ),
        defaultSmallHorizontalSpacer,
        Flexible(
          child: Text(
            list.user!.name,
            style: theme.textTheme.bodyText1,
            softWrap: false,
            overflow: TextOverflow.fade,
          ),
        ),
        defaultSmallHorizontalSpacer,
        Text(
          '@${list.user!.handle}',
          style: theme.textTheme.bodyText1,
          softWrap: false,
          overflow: TextOverflow.fade,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListCardAnimation(
      key: key,
      child: InkWell(
        borderRadius: kDefaultBorderRadius,
        onLongPress: onLongPress,
        onTap: onSelected,
        child: Card(
          child: Padding(
            padding: DefaultEdgeInsets.all(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildTitle(theme),
                if (list.hasDescription) _buildDescription(theme),
                defaultSmallVerticalSpacer,
                if (list.user != null) _buildUserRow(theme),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
