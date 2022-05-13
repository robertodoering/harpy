import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

class UserAppBar extends StatelessWidget {
  const UserAppBar({
    required this.user,
  });

  final UserData user;

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
              background: UserBanner(url: user.appropriateUserBannerUrl),
            )
          : null,
      leadingWidth: double.infinity,
      leading: const _BackButton(),
    );
  }
}

class _BackButton extends ConsumerWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(displayPreferencesProvider);

    final show = UserScrollDirection.scrollDirectionOf(context) !=
        ScrollDirection.reverse;

    return AnimatedOpacity(
      opacity: show ? 1 : 0,
      curve: Curves.easeInOut,
      duration: kShortAnimationDuration,
      child: AnimatedSlide(
        offset: show ? Offset.zero : const Offset(0, -1),
        curve: Curves.easeInOut,
        duration: kShortAnimationDuration,
        child: UnconstrainedBox(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: display.edgeInsetsOnly(left: true) / 2,
            child: HarpyButton.card(
              icon: Transform.translate(
                offset: const Offset(-1, 0),
                child: const Icon(CupertinoIcons.left_chevron),
              ),
              onTap: Navigator.of(context).maybePop,
            ),
          ),
        ),
      ),
    );
  }
}
