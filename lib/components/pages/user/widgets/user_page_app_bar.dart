import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/components/pages/user/widgets/user_page_banner.dart';
import 'package:rby/rby.dart';
import 'package:sliver_tools/sliver_tools.dart';

class UserPageAppBar extends StatelessWidget {
  const UserPageAppBar({
    required this.data,
    required this.notifier,
  });

  final UserPageData data;
  final UserPageNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    // expected aspect ratio: 3 / 1
    final expandedHeight = min<double>(
          mediaQuery.size.width * (1 / 3),
          mediaQuery.size.height * .25,
        ) -
        mediaQuery.padding.top;

    return SliverAppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      pinned: true,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      expandedHeight: expandedHeight,
      flexibleSpace: data.bannerUrl != null
          ? FlexibleSpaceBar(background: UserPageBanner(url: data.bannerUrl!))
          : null,
    );
  }
}

class UserPageAppBarButtons extends StatelessWidget {
  const UserPageAppBarButtons({
    required this.data,
    required this.notifier,
    required this.isAuthenticatedUser,
  });

  final UserPageData data;
  final UserPageNotifier notifier;
  final bool isAuthenticatedUser;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverPinnedHeader(
      child: SafeArea(
        bottom: false,
        minimum: theme.spacing.symmetric(horizontal: true).resolve(
              Directionality.of(context),
            ),
        child: Row(
          children: [
            const _BackButton(),
            const Spacer(),
            if (!isAuthenticatedUser && data.relationship != null)
              _MoreButton(relationship: data.relationship!, notifier: notifier),
          ],
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    return _UserPageAppBarButton(
      child: RbyButton.card(
        icon: Transform.translate(
          offset: const Offset(-1, 0),
          child: const Icon(CupertinoIcons.left_chevron),
        ),
        onTap: Navigator.of(context).maybePop,
      ),
    );
  }
}

enum _MoreAction {
  toggleMute,
  toggleBlock,
}

class _MoreButton extends StatelessWidget {
  const _MoreButton({
    required this.relationship,
    required this.notifier,
  });

  final RelationshipData relationship;
  final UserPageNotifier notifier;

  Future<void> _showButtonMenu(BuildContext context) async {
    // TODO: `showRbyMenu` should define the popover position itself

    final button = context.findRenderObject()! as RenderBox;
    final overlay =
        Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;

    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(
          button.size.bottomLeft(Offset.zero),
          ancestor: overlay,
        ),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    final value = await showRbyMenu(
      context: context,
      items: [
        RbyPopupMenuListTile(
          value: _MoreAction.toggleMute,
          title:
              relationship.muting ? const Text('unmute') : const Text('mute'),
        ),
        RbyPopupMenuListTile(
          value: _MoreAction.toggleBlock,
          title: relationship.blocking
              ? const Text('unblock')
              : const Text('block'),
        ),
      ],
      position: position,
    );

    if (value != null) {
      switch (value) {
        case _MoreAction.toggleMute:
          return relationship.muting ? notifier.unmute() : notifier.mute();
        case _MoreAction.toggleBlock:
          return relationship.blocking ? notifier.unblock() : notifier.block();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _UserPageAppBarButton(
      child: RbyButton.card(
        icon: const Icon(CupertinoIcons.ellipsis_vertical),
        onTap: () => _showButtonMenu(context),
      ),
    );
  }
}

class _UserPageAppBarButton extends StatelessWidget {
  const _UserPageAppBarButton({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final show = UserScrollDirection.scrollDirectionOf(context) !=
        ScrollDirection.reverse;

    return AnimatedOpacity(
      opacity: show ? 1 : 0,
      curve: Curves.easeInOut,
      duration: theme.animation.short,
      child: AnimatedScale(
        scale: show ? 1 : 0,
        curve: Curves.easeInOut,
        duration: theme.animation.short,
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: child,
        ),
      ),
    );
  }
}
