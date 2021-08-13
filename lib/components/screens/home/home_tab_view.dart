import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// todo: when switching tabs in the home tab view, consider scrolling the
//  content automatically if it is otherwise covered by the tab bar

class HomeTabView extends StatelessWidget {
  const HomeTabView();

  static const _indexOffset = 1;

  Widget _mapEntryContent(BuildContext context, int index, HomeTabEntry entry) {
    if (entry.isDefaultType) {
      switch (entry.id) {
        case 'home':
          return const HomeTimeline();
        case 'media':
          return const HomeMediaTimeline();
        case 'mentions':
          return MentionsTimeline(indexInTabView: index + _indexOffset);
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
    final mediaQuery = MediaQuery.of(context);
    final config = context.watch<ConfigCubit>().state;
    final model = context.watch<HomeTabModel>();

    return DefaultTabController(
      length: model.visibleEntries.length + 1,
      initialIndex: _indexOffset,
      child: Stack(
        children: [
          NestedScrollView(
            headerSliverBuilder: (_, __) => [
              // padding for the home app bar that is built above the nested
              // scroll view
              if (!config.bottomAppBar)
                SliverToBoxAdapter(
                  child: SizedBox(height: HomeAppBar.height(context)),
                )
              else
                SliverToBoxAdapter(
                  child: SizedBox(height: mediaQuery.padding.top),
                ),
            ],
            body: TabBarView(
              children: [
                const HomeOverview(),
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

class HomeOverview extends StatefulWidget {
  const HomeOverview();

  @override
  _HomeOverviewState createState() => _HomeOverviewState();
}

class _HomeOverviewState extends State<HomeOverview> {
  late TabController _tabController;

  double animationValue = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _tabController = DefaultTabController.of(context)!;
    _tabController.animation!.addListener(_tabControllerListener);
  }

  @override
  void dispose() {
    super.dispose();

    _tabController.animation!.removeListener(_tabControllerListener);
  }

  void _tabControllerListener() {
    if (mounted) {
      final value = 1 - _tabController.animation!.value;

      if (value >= 0 && value <= 1 && value != animationValue) {
        setState(() {
          animationValue = value;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final config = context.watch<ConfigCubit>().state;

    // todo: build home overview
    //  try staggered animation

    return Container(color: Colors.red);

    return Stack(
      children: [
        const IgnorePointer(
          ignoring: false,
          child: Opacity(
            opacity: 0,
            child: HomeDrawer(),
          ),
        ),
        Padding(
          padding: config.edgeInsets,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _AuthenticatedUser(),
              defaultVerticalSpacer,
              const _FollowersCount(),
              defaultVerticalSpacer,
              defaultVerticalSpacer,
              const Expanded(child: _Entries()),
              SizedBox(height: mediaQuery.padding.bottom),
            ],
          ),
        ),
        Container(
          alignment: Alignment.centerRight,
          child: Text(animationValue.toStringAsFixed(2)),
        ),
      ],
    );
  }
}

class _AuthenticatedUser extends StatelessWidget {
  const _AuthenticatedUser();

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigCubit>().state;
    final authCubit = context.watch<AuthenticationCubit>();
    final user = authCubit.state.user;

    if (user == null) {
      return const SizedBox();
    }

    return InkWell(
      borderRadius: kDefaultBorderRadius,
      onTap: () => app<HarpyNavigator>().pushUserProfile(
        screenName: user.handle,
      ),
      child: Card(
        child: Padding(
          padding: config.edgeInsets,
          child: Row(
            children: [
              HarpyCircleAvatar(
                radius: 28,
                imageUrl: user.appropriateUserImageUrl,
              ),
              defaultHorizontalSpacer,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    defaultSmallVerticalSpacer,
                    Text(
                      '@${user.handle}',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _FollowersCount extends StatelessWidget {
  const _FollowersCount();

  static final NumberFormat _numberFormat = NumberFormat.compact();

  @override
  Widget build(BuildContext context) {
    final authCubit = context.watch<AuthenticationCubit>();
    final user = authCubit.state.user;

    if (user == null) {
      return const SizedBox();
    }

    final friendsCount = _numberFormat.format(user.friendsCount);
    final followersCount = _numberFormat.format(user.followersCount);

    return Row(
      children: [
        Expanded(
          child: HarpyListCard(
            title: Text('$friendsCount following'),
            onTap: () => app<HarpyNavigator>().pushFollowingScreen(
              userId: user.id,
            ),
          ),
        ),
        defaultHorizontalSpacer,
        Expanded(
          child: HarpyListCard(
            title: Text('$followersCount followers'),
            onTap: () => app<HarpyNavigator>().pushFollowersScreen(
              userId: user.id,
            ),
          ),
        ),
      ],
    );
  }
}

class _Entries extends StatelessWidget {
  const _Entries();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = context.watch<ConfigCubit>().state;
    final authCubit = context.watch<AuthenticationCubit>();
    final user = authCubit.state.user;

    if (user == null) {
      return const SizedBox();
    }

    return Column(
      children: [
        HarpyListCard(
          leading: const Icon(CupertinoIcons.person),
          title: const Text('profile'),
          onTap: () => app<HarpyNavigator>().pushUserProfile(
            screenName: authCubit.state.user!.handle,
          ),
        ),
        defaultVerticalSpacer,
        HarpyListCard(
          leading: const Icon(CupertinoIcons.list_bullet),
          title: const Text('lists'),
          onTap: () => app<HarpyNavigator>().pushShowListsScreen(),
        ),
        defaultVerticalSpacer,
        HarpyListCard(
          leading: const Icon(FeatherIcons.feather),
          title: const Text('compose tweet'),
          onTap: () => app<HarpyNavigator>().pushComposeScreen(),
        ),
        defaultVerticalSpacer,
        defaultVerticalSpacer,
        HarpyListCard(
          leading: const Icon(FeatherIcons.settings),
          title: const Text('settings'),
          onTap: () => app<HarpyNavigator>().pushNamed(SettingsScreen.route),
        ),
        defaultVerticalSpacer,
        if (Harpy.isFree) ...[
          HarpyListCard(
            leading: FlareIcon.shiningStar(
              size: theme.iconTheme.size! + 8,
            ),
            leadingPadding: config.edgeInsets.copyWith(
              left: max(config.paddingValue - 4, 0),
              right: max(config.paddingValue - 4, 0),
              top: max(config.paddingValue - 4, 0),
              bottom: max(config.paddingValue - 4, 0),
            ),
            title: const Text('harpy pro'),
            subtitle: const Text('coming soon!'),
          ),
          defaultVerticalSpacer,
        ],
        HarpyListCard(
          leading: FlareIcon.harpyLogo(
            size: theme.iconTheme.size!,
          ),
          leadingPadding: config.edgeInsets.copyWith(
            left: max(config.paddingValue - 6, 0),
            right: max(config.paddingValue - 6, 0),
            top: max(config.paddingValue - 6, 0),
            bottom: max(config.paddingValue - 6, 0),
          ),
          title: const Text('about'),
          onTap: () => app<HarpyNavigator>().pushNamed(AboutScreen.route),
        ),
        const Spacer(),
        HarpyListCard(
          leading: Icon(
            CupertinoIcons.square_arrow_left,
            color: theme.colorScheme.error,
          ),
          title: const Text('logout'),
          onTap: authCubit.logout,
        ),
      ],
    );
  }
}
