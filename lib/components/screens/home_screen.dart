import 'package:flutter/material.dart';
import 'package:harpy/components/widgets/shared/cache_provider.dart';
import 'package:harpy/components/widgets/shared/home_drawer.dart';
import 'package:harpy/components/widgets/shared/scaffolds.dart';
import 'package:harpy/components/widgets/shared/service_provider.dart';
import 'package:harpy/components/widgets/tweet/tweet_list.dart';
import 'package:harpy/models/home_timeline_model.dart';

/// The [HomeScreen] showing the [TweetList] after a user has logged in.
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final serviceProvider = ServiceProvider.of(context);

    return HarpyScaffold(
      title: "Harpy",
      body: CacheProvider(
        homeTimelineCache: serviceProvider.data.homeTimelineCache,
        child: const TweetList<HomeTimelineModel>(),
      ),
      drawer: HomeDrawer(),
    );
  }
}
