import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/user.dart';
import 'package:harpy/components/widgets/user_search/user_search_delegate.dart';
import 'package:harpy/core/utils/string_utils.dart';

/// A callback returning a selected [User].
typedef OnUserSelected = void Function(User);

/// A [ListTile] for the [user] used by the [UserSearchDelegate] to display a
/// [User] in the user search results.
class UserListTile extends StatelessWidget {
  const UserListTile({
    @required this.user,
    @required this.onUserSelected,
  });

  final User user;
  final OnUserSelected onUserSelected;

  @override
  Widget build(BuildContext context) {
    // 'normal' quality for the user avatars
    final String imageUrl = user.getProfileImageUrlFromQuality(2);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.transparent,
        backgroundImage: NetworkImage(imageUrl),
      ),
      title: UserNameRow(user: user),
      subtitle: Text("@${user.screenName}"),
      trailing: Text("${prettyPrintNumber(user.followersCount)} Followers"),
      onTap: () => onUserSelected(user),
    );
  }
}

class UserNameRow extends StatelessWidget {
  const UserNameRow({
    @required this.user,
    this.style,
    this.iconSize = 16,
  });

  final User user;

  /// The [TextStyle] for the name.
  final TextStyle style;

  /// The size for the verified icon.
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        Text("${user.name}", style: style),
        if (user.verified) ...[
          const Text(" "),
          Icon(Icons.verified_user, size: iconSize),
        ],
      ],
    );
  }
}
