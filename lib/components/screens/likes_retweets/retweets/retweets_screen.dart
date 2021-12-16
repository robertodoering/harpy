import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/components/screens/likes_retweets/likes_retweets_screen.dart';
import 'package:harpy/components/screens/likes_retweets/retweets/cubit/retweets_cubit.dart';
import 'package:harpy/components/screens/likes_retweets/retweets/widgets/retweeters_sort_drawer.dart';
import 'package:harpy/components/screens/likes_retweets/sort/models/user_sort_by_model.dart';
import 'package:provider/provider.dart';

/// Builds the screen with a list of the followers for the user with the
/// [tweetId].
class RetweetsScreen extends StatefulWidget {
  const RetweetsScreen({
    required this.tweetId,
  });

  /// The [tweetId] of the user whom to search the followers for.
  final String tweetId;

  static const String route = 'retweets';

  @override
  State<RetweetsScreen> createState() => _RetweetsScreenState();
}

class _RetweetsScreenState extends State<RetweetsScreen> {
  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserListSortByModel()),
        BlocProvider(
          create: (_) =>
              RetweetsCubit(tweetId: widget.tweetId)..loadRetweetedByUsers(),
        ),
      ],
      child: const HarpyScaffold(
        endDrawer: RetweetersSortDrawer(),
        body: LikesRetweetsScreen(title: 'Retweeted By'),
      ),
    );
  }
}
