import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/rby/rby.dart';

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
          const _ConnectionsCount(),
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
  late final AnimationController _controller = AnimationController(vsync: this);

  TabController? _tabController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _tabController = HomeTabController.of(context)!
      ..animation!.addListener(_tabControllerListener);
  }

  @override
  void dispose() {
    _tabController?.animation?.removeListener(_tabControllerListener);
    _controller.dispose();

    super.dispose();
  }

  void _tabControllerListener() {
    if (mounted) {
      final value = 1 - _tabController!.animation!.value;

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
    final theme = Theme.of(context);
    final router = ref.watch(routerProvider);
    final harpyTheme = ref.watch(harpyThemeProvider);
    final padding = ref.watch(displayPreferencesProvider).edgeInsets;
    final user = ref.watch(authenticationStateProvider).user;

    if (user == null) {
      return const SizedBox();
    }

    return InkWell(
      borderRadius: harpyTheme.borderRadius,
      onTap: () => router.pushNamed(
        UserPage.name,
        params: {'handle': user.handle},
        extra: user,
      ),
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
                      style: theme.textTheme.headline5,
                    ),
                    smallVerticalSpacer,
                    Text(
                      '@${user.handle}',
                      style: theme.textTheme.subtitle1,
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

class _ConnectionsCount extends ConsumerWidget {
  const _ConnectionsCount();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final user = ref.watch(authenticationStateProvider).user;

    if (user == null) {
      return const SizedBox();
    }

    return Row(
      children: [
        Expanded(
          child: ConnectionCount(
            count: user.friendsCount,
            builder: (count) => HarpyListCard(
              title: Text('$count  following'),
              multilineTitle: true,
              onTap: () => router.pushNamed(
                FollowingPage.name,
                params: {'handle': user.handle},
              ),
            ),
          ),
        ),
        horizontalSpacer,
        Expanded(
          child: ConnectionCount(
            count: user.followersCount,
            builder: (count) => HarpyListCard(
              title: Text('$count  followers'),
              multilineTitle: true,
              onTap: () => router.pushNamed(
                FollowersPage.name,
                params: {'handle': user.handle},
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Entries extends ConsumerWidget {
  const _Entries(this.controller);

  final AnimationController controller;

  List<Widget> _animate(
    List<Widget> children, {
    required TextDirection directionality,
  }) {
    final animated = <Widget>[];

    for (var i = 0; i < children.length; i++) {
      final offsetAnimation = Tween<Offset>(
        begin: Offset(
          lerpDouble(
            directionality == TextDirection.ltr ? -.3 : .3,
            directionality == TextDirection.ltr ? -2 : 2,
            i / children.length,
          )!,
          0,
        ),
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
    final router = ref.watch(routerProvider);
    final general = ref.watch(generalPreferencesProvider);
    final user = ref.watch(authenticationStateProvider).user;

    final directionality = Directionality.of(context);

    if (user == null) return const SizedBox();

    final children = [
      HarpyListCard(
        leading: const Icon(CupertinoIcons.person),
        title: const Text('profile'),
        onTap: () => router.pushNamed(
          UserPage.name,
          params: {'handle': user.handle},
          extra: user,
        ),
      ),
      verticalSpacer,
      HarpyListCard(
        leading: const Icon(CupertinoIcons.search),
        title: const Text('search'),
        onTap: () => router.pushNamed(SearchPage.name),
      ),
      verticalSpacer,
      HarpyListCard(
        leading: const Icon(CupertinoIcons.list_bullet),
        title: const Text('lists'),
        onTap: () => router.pushNamed(
          ListShowPage.name,
          params: {'handle': user.handle},
        ),
      ),
      verticalSpacer,
      HarpyListCard(
        leading: const Icon(FeatherIcons.feather),
        title: const Text('compose'),
        onTap: () => router.pushNamed(ComposePage.name),
      ),
      verticalSpacer,
      verticalSpacer,
      HarpyListCard(
        leading: const Icon(Icons.settings_rounded),
        title: const Text('settings'),
        onTap: () => router.pushNamed(SettingsPage.name),
      ),
      verticalSpacer,
      if (isFree) ...[
        HarpyListCard(
          leading: const FlareIcon.shiningStar(),
          title: const Text('harpy pro'),
          onTap: () => safeLaunchUrl(
            'https://play.google.com/store/apps/details?id=com.robertodoering.harpy.pro',
          ),
        ),
        verticalSpacer,
      ],
      HarpyListCard(
        leading: const FlareIcon.harpyLogo(),
        title: const Text('about'),
        onTap: () => router.pushNamed(AboutPage.name),
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
          final result = await showDialog<bool>(
            context: context,
            builder: (_) => const LogoutDialog(),
          );

          if (result ?? false) ref.read(logoutProvider).logout().ignore();
        },
      ),
    ];

    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) => Column(
        children: general.performanceMode
            ? children
            : _animate(
                children,
                directionality: directionality,
              ),
      ),
    );
  }
}
