import 'package:flutter/material.dart';
import 'package:harpy/components/common/list/scroll_direction_listener.dart';
import 'package:harpy/components/common/misc/harpy_scaffold.dart';
import 'package:harpy/components/common/misc/harpy_sliver_app_bar.dart';
import 'package:harpy/components/search/widgets/search_text_field.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';
import 'package:harpy/components/user/widgets/user_list.dart';
import 'package:harpy/core/api/twitter/user_data.dart';

class UserSearchScreen extends StatelessWidget {
  const UserSearchScreen();

  static const String route = 'user_search_screen';

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    return HarpyScaffold(
      body: ScrollDirectionListener(
        child: UserList(
          <UserData>[],
          beginSlivers: <Widget>[
            HarpySliverAppBar(
              title: 'Search users',
              floating: true,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: Padding(
                  padding: DefaultEdgeInsets.all(),
                  child: const SearchTextField(),
                ),
              ),
            ),
          ],
          endSlivers: <Widget>[
            SliverToBoxAdapter(
              child: SizedBox(height: mediaQuery.padding.bottom),
            )
          ],
        ),
      ),
    );
  }
}
