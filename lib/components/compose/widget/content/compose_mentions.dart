import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/paginated_bloc/paginated_state.dart';
import 'package:harpy/components/compose/bloc/compose_bloc.dart';
import 'package:harpy/components/compose/widget/content/compose_suggestions.dart';
import 'package:harpy/components/search/user/bloc/user_search_bloc.dart';
import 'package:harpy/components/search/user/bloc/user_search_event.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';
import 'package:harpy/core/api/twitter/user_data.dart';

/// Displays user mention suggestions after typing `@`.
class ComposeTweetMentions extends StatelessWidget {
  const ComposeTweetMentions(
    this.bloc, {
    @required this.controller,
  });

  final ComposeBloc bloc;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserSearchBloc>(
      create: (BuildContext context) => UserSearchBloc(),
      child: BlocBuilder<UserSearchBloc, PaginatedState>(
        builder: (BuildContext context, PaginatedState state) {
          final UserSearchBloc userSearchBloc = UserSearchBloc.of(context);

          Widget child;

          // todo: display user and insert the username on tap

          if (userSearchBloc.hasData) {
            child = ListView(
              padding: EdgeInsets.all(defaultSmallPaddingValue),
              shrinkWrap: true,
              children: userSearchBloc.users
                  .map((UserData user) => Text(user.screenName))
                  .toList(),
            );
          }

          return ComposeTweetSuggestions(
            bloc,
            controller: controller,
            identifier: '@',
            onSearch: (String query) {
              userSearchBloc.add(SearchUsers(query));
            },
            child: child,
          );
        },
      ),
    );
  }
}
