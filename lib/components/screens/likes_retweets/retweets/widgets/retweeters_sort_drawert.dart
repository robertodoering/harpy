import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/components/screens/likes_retweets/retweets/cubit/retweets_cubit.dart';
import 'package:harpy/components/screens/likes_retweets/sort/models/like_sort_by_model.dart';
import 'package:harpy/components/screens/likes_retweets/sort/widgets/user_list_sort_drawer.dart';
import 'package:provider/provider.dart';

class RetweetersSortDrawer extends StatelessWidget {
  const RetweetersSortDrawer();

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<RetweetsCubit>();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserListSortByModel.sort()),
      ],
      builder: (context, child) {
        return UserListSortDrawer(
          title: 'user list sort order',
          showFilterButton: true,
          onFilter: () {
            cubit.applySort(context, cubit.tweetId);
          },
          onClear: () {
            if (cubit.sort != ListSortBy.empty) {
              ScrollDirection.of(context)?.reset();
              cubit.applySort(context, cubit.tweetId);
            }
          },
        );
      },
    );
  }
}
