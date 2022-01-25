import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

/// A fullscreen-sized navigation drawer for the [HomeTabView].
///
/// Entries are animated dynamically based on the animation in the tab view.
class HomeDrawer extends StatelessWidget {
  const HomeDrawer();

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigCubit>().state;

    return _DrawerAnimationListener(
      builder: (context) {
        final animationController = context.watch<AnimationController>();

        return ListView(
          padding: config.edgeInsets,
          children: [
            const HomeTopPadding(),
            const _AuthenticatedUser(),
            verticalSpacer,
            const _FollowersCount(),
            verticalSpacer,
            verticalSpacer,
            _Entries(animationController),
            const HomeBottomPadding(),
          ],
        );
      },
    );
  }
}

class _DrawerAnimationListener extends StatefulWidget {
  const _DrawerAnimationListener({
    required this.builder,
  });

  final WidgetBuilder builder;

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

    _tabController = DefaultTabController.of(context)!;
    _tabController.animation!.addListener(_tabControllerListener);
  }

  @override
  void dispose() {
    _tabController.animation!.removeListener(_tabControllerListener);
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
    return ListenableProvider(
      create: (_) => _controller,
      child: Builder(builder: widget.builder),
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
      borderRadius: kBorderRadius,
      onTap: () => app<HarpyNavigator>().pushUserProfile(initialUser: user),
      child: Card(
        child: Padding(
          padding: config.edgeInsets,
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
            title: Text('$friendsCount  following'),
            onTap: () => app<HarpyNavigator>().pushFollowingScreen(
              userId: user.id,
            ),
          ),
        ),
        horizontalSpacer,
        Expanded(
          child: HarpyListCard(
            title: Text('$followersCount  followers'),
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
        ShiftedPosition(
          shift: offsetAnimation.value,
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = context.watch<ConfigCubit>().state;
    final authCubit = context.watch<AuthenticationCubit>();
    final user = authCubit.state.user;

    if (user == null) {
      return const SizedBox();
    }

    final children = [
      HarpyListCard(
        leading: const Icon(CupertinoIcons.person),
        title: const Text('profile'),
        onTap: () => app<HarpyNavigator>().pushUserProfile(
          initialUser: authCubit.state.user,
        ),
      ),
      verticalSpacer,
      HarpyListCard(
        leading: const Icon(CupertinoIcons.search),
        title: const Text('search'),
        onTap: () => app<HarpyNavigator>().pushSearchScreen(
          trendsCubit: context.read<TrendsCubit>(),
          trendsLocationsCubit: context.read<TrendsLocationsCubit>(),
        ),
      ),
      verticalSpacer,
      HarpyListCard(
        leading: const Icon(CupertinoIcons.list_bullet),
        title: const Text('lists'),
        onTap: () => app<HarpyNavigator>().pushShowListsScreen(),
      ),
      verticalSpacer,
      HarpyListCard(
        leading: const Icon(FeatherIcons.feather),
        title: const Text('compose'),
        onTap: () => app<HarpyNavigator>().pushComposeScreen(),
      ),
      verticalSpacer,
      verticalSpacer,
      HarpyListCard(
        leading: const Icon(FeatherIcons.settings),
        title: const Text('settings'),
        onTap: () => app<HarpyNavigator>().pushNamed(SettingsScreen.route),
      ),
      verticalSpacer,
      if (isFree) ...[
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
          onTap: () => launchUrl(
            'https://play.google.com/store/apps/details?id=com.robertodoering.harpy.pro',
          ),
        ),
        verticalSpacer,
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
      verticalSpacer,
      verticalSpacer,
      HarpyListCard(
        leading: Icon(
          CupertinoIcons.square_arrow_left,
          color: theme.colorScheme.error,
        ),
        title: const Text('logout'),
        onTap: () async {
          final logout = await showDialog<bool>(
            context: context,
            builder: (_) => const HarpyLogoutDialog(),
          );

          if (logout != null && logout) {
            await authCubit.logout();
          }
        },
      ),
    ];

    return Column(
      children: app<GeneralPreferences>().performanceMode
          ? children
          : _animate(children),
    );
  }
}
