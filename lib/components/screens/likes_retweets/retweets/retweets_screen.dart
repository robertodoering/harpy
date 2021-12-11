import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/components/screens/likes_retweets/likes_retweets_screen.dart';
import 'package:harpy/components/screens/likes_retweets/retweets/cubit/retweets_cubit.dart';
import 'package:harpy/components/screens/likes_retweets/retweets/widgets/retweeters_sort_drawert.dart';
import 'package:harpy/components/screens/likes_retweets/sort/models/like_sort_by_model.dart';
import 'package:provider/provider.dart';

/// Builds the screen with a list of the followers for the user with the
/// [tweetId].
class RetweetsScreen extends StatefulWidget {
  const RetweetsScreen({
    required this.tweetId,
    this.sort,
  });

  /// The [tweetId] of the user whom to search the followers for.
  final String tweetId;

  /// The [sort] of the how to order the users displayed
  final String? sort;

  static const String route = 'retweets';

  @override
  State<RetweetsScreen> createState() => _RetweetsScreenState();
}

class _RetweetsScreenState extends State<RetweetsScreen> {
  @override
  void initState() {
    super.initState();

    ChangelogDialog.maybeShow(context);

    context.read<RetweetsCubit>().loadRetweetedByUsers();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopHarpy(
      child: MultiProvider(
        providers: [
          BlocProvider(
            create: (_) =>
                RetweetsCubit(tweetId: widget.tweetId)..loadRetweetedByUsers(),
          ),
          ChangeNotifierProvider(create: (_) => UserListSortByModel.sort()),
        ],
        child: const HarpyScaffold(
          endDrawer: RetweetersSortDrawer(),
          body: LikesRetweetsScreen(title: 'Retweeted By'),
        ),
      ),
    );
  }
}
