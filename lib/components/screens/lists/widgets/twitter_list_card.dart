import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

class TwitterListCard extends StatelessWidget {
  const TwitterListCard(this.list, {Key key}) : super(key: key);

  final TwitterListData list;

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
      list.description,
      style: theme.textTheme.bodyText1,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildUserRow(ThemeData theme) {
    return Row(
      children: <Widget>[
        CachedCircleAvatar(
          imageUrl: list.user.profileImageUrlHttps,
          radius: 8,
        ),
        defaultSmallHorizontalSpacer,
        Flexible(
          child: Text(
            '${list.user.name}',
            style: theme.textTheme.bodyText1,
            softWrap: false,
            overflow: TextOverflow.fade,
          ),
        ),
        defaultSmallHorizontalSpacer,
        Text(
          '@${list.user.screenName}',
          style: theme.textTheme.bodyText1,
          softWrap: false,
          overflow: TextOverflow.fade,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return ListCardAnimation(
      key: key,
      child: Card(
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: DefaultEdgeInsets.all(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildTitle(theme),
                if (list.hasDescription) ...<Widget>[
                  _buildDescription(theme),
                  defaultSmallVerticalSpacer,
                ],
                _buildUserRow(theme),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
