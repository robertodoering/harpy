import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';

class LegacyUserAppBar extends StatelessWidget {
  const LegacyUserAppBar({
    required this.user,
  });

  final LegacyUserData user;

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
      expandedHeight: user.hasBanner ? expandedHeight : null,
      flexibleSpace: user.hasBanner
          ? FlexibleSpaceBar(
              background: LegacyUserBanner(url: user.appropriateUserBannerUrl),
            )
          : null,
      leadingWidth: double.infinity,
      leading: const _BackButton(),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final show = UserScrollDirection.scrollDirectionOf(context) !=
        ScrollDirection.reverse;

    return AnimatedOpacity(
      opacity: show ? 1 : 0,
      curve: Curves.easeInOut,
      duration: theme.animation.short,
      child: AnimatedSlide(
        offset: show ? Offset.zero : const Offset(0, -1),
        curve: Curves.easeInOut,
        duration: theme.animation.short,
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: RbyButton.card(
            icon: Transform.translate(
              offset: const Offset(-1, 0),
              child: const Icon(CupertinoIcons.left_chevron),
            ),
            onTap: Navigator.of(context).maybePop,
          ),
        ),
      ),
    );
  }
}
