import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';

/// Builds a sliver app bar for the [UserSearchScreen] with a [SearchTextField]
/// in the title.
class UserSearchAppBar extends StatelessWidget {
  const UserSearchAppBar();

  @override
  Widget build(BuildContext context) {
    final UserSearchBloc bloc = context.watch<UserSearchBloc>();

    return HarpySliverAppBar(
      titleWidget: SearchTextField(
        autofocus: true,
        hintText: 'search users',
        onSubmitted: (String text) {
          if (text.trim().isNotEmpty) {
            bloc..add(const ClearSearchedUsers())..add(SearchUsers(text));
          }
        },
        onClear: () => bloc.add(const ClearSearchedUsers()),
      ),
      floating: true,
    );
  }
}
