import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';

class HomeTopPadding extends ConsumerWidget {
  const HomeTopPadding();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaQuery = MediaQuery.of(context);
    final general = ref.watch(generalPreferencesProvider);
    final display = ref.watch(displayPreferencesProvider);

    return general.bottomAppBar
        ? SizedBox(height: mediaQuery.padding.top)
        : SizedBox(
            height: HomeAppBar.height(
              context,
              general: general,
              display: display,
            ),
          );
  }
}

class HomeTopSliverPadding extends StatelessWidget {
  const HomeTopSliverPadding();

  @override
  Widget build(BuildContext context) {
    return const SliverToBoxAdapter(
      child: HomeTopPadding(),
    );
  }
}

class HomeBottomPadding extends ConsumerWidget {
  const HomeBottomPadding();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaQuery = MediaQuery.of(context);
    final general = ref.watch(generalPreferencesProvider);
    final display = ref.watch(displayPreferencesProvider);

    return general.bottomAppBar
        ? SizedBox(
            height: HomeAppBar.height(
              context,
              general: general,
              display: display,
            ),
          )
        : SizedBox(height: mediaQuery.padding.bottom);
  }
}

class HomeBottomSliverPadding extends StatelessWidget {
  const HomeBottomSliverPadding();

  @override
  Widget build(BuildContext context) {
    return const SliverToBoxAdapter(
      child: HomeBottomPadding(),
    );
  }
}
