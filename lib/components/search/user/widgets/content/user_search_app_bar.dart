import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/misc/harpy_sliver_app_bar.dart';
import 'package:harpy/components/search/user/bloc/user_search_bloc.dart';
import 'package:harpy/components/search/user/bloc/user_search_event.dart';
import 'package:harpy/components/search/widgets/search_text_field.dart';

/// Builds a sliver app bar with a [SearchTextField] in the title.
class UserSearchAppBar extends StatelessWidget {
  const UserSearchAppBar();

  @override
  Widget build(BuildContext context) {
    final UserSearchBloc bloc = context.watch<UserSearchBloc>();

    return HarpySliverAppBar(
      titleWidget: Container(
        child: SearchTextField(
          requestFocus: true,
          hintText: 'Search users',
          onSubmitted: (String text) {
            if (text.trim().isNotEmpty) {
              bloc..add(const ClearSearchedUsers())..add(SearchUsers(text));
            }
          },
          onClear: () => bloc.add(const ClearSearchedUsers()),
        ),
      ),
      floating: true,
    );
  }
}
