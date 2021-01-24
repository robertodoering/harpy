import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/misc/harpy_scaffold.dart';
import 'package:harpy/components/search/tweet/bloc/tweet_search_bloc.dart';
import 'package:harpy/components/search/tweet/filter/model/tweet_search_filter.dart';
import 'package:harpy/components/search/tweet/filter/model/tweet_search_filter_model.dart';
import 'package:harpy/components/search/tweet/filter/widgets/tweet_search_filter_drawer.dart';
import 'package:harpy/components/search/tweet/widgets/content/tweet_search_list.dart';
import 'package:provider/provider.dart';

class TweetSearchScreen extends StatelessWidget {
  const TweetSearchScreen();

  static const String route = 'tweet_search_screen';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TweetSearchFilterModel>(
      create: (_) => TweetSearchFilterModel(const TweetSearchFilter()),
      child: BlocProvider<TweetSearchBloc>(
        create: (_) => TweetSearchBloc(),
        child: const HarpyScaffold(
          endDrawer: TweetSearchFilterDrawer(),
          body: TweetSearchList(),
        ),
      ),
    );
  }
}
