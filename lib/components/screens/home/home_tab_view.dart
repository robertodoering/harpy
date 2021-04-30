import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/tab_controller.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:provider/provider.dart';

// todo: when switching tabs in the home tab view, consider scrolling the
//  content automatically if it is otherwise covered by the tab bar

class HomeTabView extends StatelessWidget {
  // non-const to always rebuild when returning to home screen
  // ignore: prefer_const_constructors_in_immutables
  HomeTabView();

  Widget _mapEntryContent(BuildContext context, int index, HomeTabEntry entry) {
    if (entry.isDefaultType) {
      switch (entry.id) {
        case 'home':
          return HomeTimeline();
        case 'media':
          return const HomeMediaTimeline();
        case 'mentions':
          return MentionsTimeline(indexInTabView: index);
        case 'search':
          return const SearchScreen();
        default:
          return const SizedBox();
      }
    } else if (entry.isListType) {
      return HomeListTimeline(listId: entry.id);
    } else {
      return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final HomeTabModel model = context.watch<HomeTabModel>();

    return DefaultTabController(
      length: model.visibleEntries.length,
      child: Stack(
        children: <Widget>[
          NestedScrollView(
            headerSliverBuilder: (_, __) => <Widget>[
              // padding for the home app bar that is built above the nested
              // scroll view
              SliverToBoxAdapter(
                child: SizedBox(
                  height: HomeAppBar.height(mediaQuery.padding.top - 8),
                ),
              ),
            ],
            body: TabBarView(
              children: <Widget>[
                for (int i = 0; i < model.visibleEntries.length; i++)
                  _mapEntryContent(context, i, model.visibleEntries[i]),
              ],
            ),
          ),
          const HomeAppBar(),
        ],
      ),
    );
  }
}
