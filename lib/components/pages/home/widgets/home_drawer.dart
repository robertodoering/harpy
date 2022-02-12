import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:intl/intl.dart';

typedef AnimatedWidgetBuilder = Widget Function(
  AnimationController controller,
);

/// A fullscreen-sized navigation drawer for the [HomeTabView].
class HomeDrawer extends ConsumerWidget {
  const HomeDrawer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final padding = ref.watch(displayPreferencesProvider).edgeInsets;

    return _DrawerAnimationListener(
      builder: (controller) => ListView(
        padding: padding,
        children: [
          const HomeTopPadding(),
          const _AuthenticatedUser(),
          verticalSpacer,
          const _FollowersCount(),
          verticalSpacer,
          verticalSpacer,
          _Entries(controller),
          const HomeBottomPadding(),
        ],
      ),
    );
  }
}

/// Listens to the animation of the [DefaultTabController] and exposes its value
/// in the [builder].
class _DrawerAnimationListener extends StatefulWidget {
  const _DrawerAnimationListener({
    required this.builder,
  });

  final AnimatedWidgetBuilder builder;

  @override
  _DrawerAnimationListenerState createState() =>
      _DrawerAnimationListenerState();
}

class _DrawerAnimationListenerState extends State<_DrawerAnimationListener>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final tabController = DefaultTabController.of(context);
    assert(tabController != null);
    assert(tabController?.animation != null);

    _tabController = tabController!
      ..animation?.addListener(_tabControllerListener);
  }

  @override
  void dispose() {
    _tabController.animation?.removeListener(_tabControllerListener);
    _controller.dispose();

    super.dispose();
  }

  void _tabControllerListener() {
    if (mounted) {
      final value = 1 - _tabController.animation!.value;

      if (value >= 0 && value <= 1 && value != _controller.value) {
        _controller.value = value;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(_controller);
  }
}

class _AuthenticatedUser extends ConsumerWidget {
  const _AuthenticatedUser();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final harpyTheme = ref.watch(harpyThemeProvider);
    final padding = ref.watch(displayPreferencesProvider).edgeInsets;
    final user = ref.watch(authenticationStateProvider).user;

    if (user == null) {
      return const SizedBox();
    }

    return InkWell(
      borderRadius: harpyTheme.borderRadius,
      // TODO: Navigate to user profile
      // onTap: () => app<HarpyNavigator>().pushUserProfile(initialUser: user),
      child: Card(
        child: Padding(
          padding: padding,
          child: Row(
            children: [
              HarpyCircleAvatar(
                radius: 28,
                imageUrl: user.appropriateUserImageUrl,
              ),
              horizontalSpacer,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    smallVerticalSpacer,
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

class _FollowersCount extends ConsumerWidget {
  const _FollowersCount();

  static final _numberFormat = NumberFormat.compact();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authenticationStateProvider).user;

    if (user == null) {
      return const SizedBox();
    }

    final friendsCount = _numberFormat.format(user.friendsCount);
    final followersCount = _numberFormat.format(user.followersCount);

    return Row(
      children: [
        Expanded(
          child: HarpyListCard(
            title: Text('$friendsCount  following'),
            // TODO: push following screen
            // onTap: () => app<HarpyNavigator>().pushFollowingScreen(
            //   userId: user.id,
            // ),
          ),
        ),
        horizontalSpacer,
        Expanded(
          child: HarpyListCard(
            title: Text('$followersCount  followers'),
            // TODO: push following screen
            // onTap: () => app<HarpyNavigator>().pushFollowersScreen(
            //   userId: user.id,
            // ),
          ),
        ),
      ],
    );
  }
}

class _Entries extends ConsumerWidget {
  const _Entries(this.controller);

  final AnimationController controller;

  List<Widget> _animate(List<Widget> children) {
    final animated = <Widget>[];

    for (var i = 0; i < children.length; i++) {
      final offsetAnimation = Tween<Offset>(
        begin: Offset(lerpDouble(-.3, -2, i / children.length)!, 0),
        end: Offset.zero,
      ).animate(controller);

      animated.add(
        FractionalTranslation(
          translation: offsetAnimation.value,
          child: Opacity(
            opacity: controller.value,
            child: children[i],
          ),
        ),
      );
    }

    return animated;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final general = ref.watch(generalPreferencesProvider);
    final user = ref.watch(authenticationStateProvider).user;

    if (user == null) {
      return const SizedBox();
    }

    final children = [
      const HarpyListCard(
        leading: Icon(CupertinoIcons.person),
        title: Text('profile'),
        // TODO: push user profile page
        // onTap: () => app<HarpyNavigator>().pushUserProfile(
        //   initialUser: authCubit.state.user,
        // ),
      ),
      verticalSpacer,
      const HarpyListCard(
        leading: Icon(CupertinoIcons.search),
        title: Text('search'),
        // TODO: push search page
        // onTap: () => app<HarpyNavigator>().pushSearchScreen(
        //   trendsCubit: context.read<TrendsCubit>(),
        //   trendsLocationsCubit: context.read<TrendsLocationsCubit>(),
        // ),
      ),
      verticalSpacer,
      const HarpyListCard(
        leading: Icon(CupertinoIcons.list_bullet),
        title: Text('lists'),
        // TODO: push lists
        // onTap: () => app<HarpyNavigator>().pushShowListsScreen(),
      ),
      verticalSpacer,
      const HarpyListCard(
        leading: Icon(FeatherIcons.feather),
        title: Text('compose'),
        // TODO: push compose page
        // onTap: () => app<HarpyNavigator>().pushComposeScreen(),
      ),
      verticalSpacer,
      verticalSpacer,
      const HarpyListCard(
        leading: Icon(FeatherIcons.settings),
        title: Text('settings'),
        // TODO: settings screen
        // onTap: () => app<HarpyNavigator>().pushNamed(SettingsScreen.route),
      ),
      verticalSpacer,
      if (isFree) ...[
        const HarpyListCard(
          // TODO: shining star icon
          // leading: FlareIcon.shiningStar(
          //   size: theme.iconTheme.size! + 8,
          // ),
          // leadingPadding: config.edgeInsets.copyWith(
          //   left: max(config.paddingValue - 4, 0),
          //   right: max(config.paddingValue - 4, 0),
          //   top: max(config.paddingValue - 4, 0),
          //   bottom: max(config.paddingValue - 4, 0),
          // ),
          title: Text('harpy pro'),
          // onTap: () => launchUrl(
          //   'https://play.google.com/store/apps/details?id=com.robertodoering.harpy.pro',
          // ),
        ),
        verticalSpacer,
      ],
      const HarpyListCard(
        // TODO: harpy logo icon
        // leading: FlareIcon.harpyLogo(
        //   size: theme.iconTheme.size!,
        // ),
        // leadingPadding: config.edgeInsets.copyWith(
        //   left: max(config.paddingValue - 6, 0),
        //   right: max(config.paddingValue - 6, 0),
        //   top: max(config.paddingValue - 6, 0),
        //   bottom: max(config.paddingValue - 6, 0),
        // ),
        title: Text('about'),
        // TODO: push about screen
        // onTap: () => app<HarpyNavigator>().pushNamed(AboutScreen.route),
      ),
      verticalSpacer,
      verticalSpacer,
      HarpyListCard(
        leading: Icon(
          CupertinoIcons.square_arrow_left,
          color: theme.colorScheme.error,
        ),
        title: const Text('logout'),
        // TODO: logout dialog
        // onTap: () async {
        //   final logout = await showDialog<bool>(
        //     context: context,
        //     builder: (_) => const HarpyLogoutDialog(),
        //   );

        //   if (logout != null && logout) {
        //     await authCubit.logout();
        //   }
        // },
      ),
    ];

    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) => Column(
        children: general.performanceMode ? children : _animate(children),
      ),
    );
  }
}
